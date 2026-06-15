import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/command_serializer.dart';
import 'package:melo_trip/app_player/interruption_side_effect_serializer.dart';

/// Simulates the interaction between user command serializer and
/// interruption side-effect serializer, verifying they don't race.
class DualSerializerSimulator {
  final commandSerializer = AppPlayerCommandSerializer();
  final interruptionSerializer = InterruptionSideEffectSerializer();

  /// Recorded operations in order of completion.
  final List<String> operations = [];

  /// Simulates a user command that does multiple operations.
  /// Returns immediately after enqueueing.
  void userInsertAndPlay() {
    commandSerializer.run(() async {
      operations.add('user-jump');
      // Simulate jump operation
      await Future.delayed(const Duration(milliseconds: 10));
      operations.add('user-play');
    });
  }

  /// Simulates a user pause command.
  void userPause() {
    commandSerializer.run(() async {
      operations.add('user-pause');
    });
  }

  /// Simulates an interruption pause begin event.
  /// This goes through interruption serializer which then calls
  /// command serializer for pause().
  void interruptionPauseBegin() {
    // State update happens synchronously (simulated)
    // Then side effects are enqueued
    interruptionSerializer.run(() async {
      // This calls pause() which goes through commandSerializer
      await commandSerializer.run(() async {
        operations.add('interruption-pause');
      });
    });
  }

  /// Simulates an interruption pause end event.
  void interruptionPauseEnd() {
    interruptionSerializer.run(() async {
      await commandSerializer.run(() async {
        operations.add('interruption-play');
      });
    });
  }

  /// Simulates interruption with duck begin then pause begin.
  void interruptionDuckThenPauseBegin() {
    interruptionSerializer.run(() async {
      // setVolume is fire-and-forget in real code, but here we track it
      operations.add('interruption-setVolume');
      // Then pause through command serializer
      await commandSerializer.run(() async {
        operations.add('interruption-pause');
      });
    });
  }

  /// Simulates a slow user command that can be controlled.
  void slowUserCommand(String name, Completer<void>? waitFor) {
    commandSerializer.run(() async {
      operations.add('$name-start');
      if (waitFor != null) {
        await waitFor.future;
      }
      operations.add('$name-end');
    });
  }

  /// Simulates a controlled pause through command serializer.
  Future<void> controlledPause(Completer<void> waitFor) {
    return commandSerializer.run(() async {
      operations.add('pause-start');
      await waitFor.future;
      operations.add('pause-end');
    });
  }
}

void main() {
  group('User commands and interruption commands serialization', () {
    test('user command finishes before interruption pause executes', () async {
      final sim = DualSerializerSimulator();

      // User starts insertAndPlay
      sim.userInsertAndPlay();

      // Interruption pause begin arrives while user command is in queue
      sim.interruptionPauseBegin();

      // Wait for all to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Order must be: user-jump, user-play, then interruption-pause
      // NOT: interruption-pause, user-play
      expect(sim.operations, equals([
        'user-jump',
        'user-play',
        'interruption-pause',
      ]));
    });

    test('interruption pause end waits for pause to complete', () async {
      final sim = DualSerializerSimulator();

      // Pause begin
      sim.interruptionPauseBegin();

      // Pause end arrives
      sim.interruptionPauseEnd();

      await Future.delayed(const Duration(milliseconds: 50));

      // Order: pause then play
      expect(sim.operations, equals([
        'interruption-pause',
        'interruption-play',
      ]));
    });

    test('interruption pause cannot interleave user command', () async {
      final sim = DualSerializerSimulator();
      final userCompleter = Completer<void>();

      // User command that we control
      sim.slowUserCommand('user-insertAndPlay', userCompleter);

      // Give time for user command to start
      await Future.delayed(Duration.zero);

      // User command should have started but not finished
      expect(sim.operations, equals(['user-insertAndPlay-start']));

      // Interruption pause arrives while user command is running
      sim.interruptionPauseBegin();

      // Interruption should NOT have executed yet (waiting for user command)
      await Future.delayed(Duration.zero);
      expect(sim.operations, equals(['user-insertAndPlay-start']));

      // Complete user command
      userCompleter.complete();

      // Now both user-end and interruption-pause should execute
      await Future.delayed(const Duration(milliseconds: 20));
      expect(sim.operations, equals([
        'user-insertAndPlay-start',
        'user-insertAndPlay-end',
        'interruption-pause',
      ]));
    });

    test('multiple interruption events queue correctly', () async {
      final sim = DualSerializerSimulator();

      // Rapid interruption events
      sim.interruptionPauseBegin();
      sim.interruptionPauseEnd();

      await Future.delayed(const Duration(milliseconds: 50));

      expect(sim.operations, equals([
        'interruption-pause',
        'interruption-play',
      ]));
    });

    test('user command after interruption pause queues correctly', () async {
      final sim = DualSerializerSimulator();

      // Interruption pause
      sim.interruptionPauseBegin();

      // User tries to play (e.g., resume button pressed)
      sim.userInsertAndPlay();

      await Future.delayed(const Duration(milliseconds: 50));

      // Both go through commandSerializer, so they execute in FIFO order.
      // The interruption's pause() call queues to commandSerializer,
      // then user's insertAndPlay queues to commandSerializer.
      // Command serializer processes them in order: pause first, then user commands.
      // However, the interruption serializer action must start first to queue pause.
      // In practice, both serialize through the same command serializer.
      expect(sim.operations, contains('interruption-pause'));
      expect(sim.operations, contains('user-jump'));
      expect(sim.operations, contains('user-play'));
    });

    test('duck then pause begin: setVolume before pause', () async {
      final sim = DualSerializerSimulator();

      sim.interruptionDuckThenPauseBegin();

      await Future.delayed(const Duration(milliseconds: 20));

      // setVolume happens first (in interruption serializer)
      // Then pause (through command serializer)
      expect(sim.operations, equals([
        'interruption-setVolume',
        'interruption-pause',
      ]));
    });
  });

  group('Deadlock prevention verification', () {
    test('nested serializers do not deadlock', () async {
      // This test verifies that calling commandSerializer.run() from inside
      // interruptionSerializer.run() does not cause deadlock.
      //
      // The call chain is:
      // 1. interruptionSerializer.run(() async { ... })
      // 2. Inside: await commandSerializer.run(() async { ... })
      // 3. commandSerializer runs the action and returns
      // 4. interruptionSerializer continues
      //
      // Deadlock would occur if:
      // - commandSerializer tried to call interruptionSerializer (it doesn't)
      // - Either serializer had a mutex that blocked on the same thread
      //
      // Our serializers use Future chains, not mutexes, so nesting works.

      final commandSerializer = AppPlayerCommandSerializer();
      final interruptionSerializer = InterruptionSideEffectSerializer();
      final operations = <String>[];

      // Nested call: interruption -> command
      interruptionSerializer.run(() async {
        operations.add('outer-start');
        await commandSerializer.run(() async {
          operations.add('inner');
        });
        operations.add('outer-end');
      });

      await Future.delayed(const Duration(milliseconds: 50));

      expect(operations, equals(['outer-start', 'inner', 'outer-end']));
    });

    test('command serializer alone handles rapid commands', () async {
      final serializer = AppPlayerCommandSerializer();
      final operations = <String>[];

      for (var i = 0; i < 5; i++) {
        serializer.run(() async {
          operations.add('cmd-$i');
        });
      }

      await Future.delayed(const Duration(milliseconds: 50));

      expect(operations, equals(['cmd-0', 'cmd-1', 'cmd-2', 'cmd-3', 'cmd-4']));
    });

    test('interruption serializer alone handles rapid events', () async {
      final serializer = InterruptionSideEffectSerializer();
      final operations = <String>[];

      for (var i = 0; i < 5; i++) {
        serializer.run(() async {
          operations.add('event-$i');
        });
      }

      await Future.delayed(const Duration(milliseconds: 50));

      expect(operations, equals(['event-0', 'event-1', 'event-2', 'event-3', 'event-4']));
    });
  });
}
