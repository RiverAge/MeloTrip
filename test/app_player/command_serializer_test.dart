import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/command_serializer.dart';

void main() {
  group('AppPlayerCommandSerializer', () {
    test('serializes commands in order', () async {
      final serializer = AppPlayerCommandSerializer();
      final executionOrder = <int>[];

      final future1 = serializer.run(() async {
        executionOrder.add(1);
        await Future.delayed(const Duration(milliseconds: 50));
        executionOrder.add(2);
      });

      final future2 = serializer.run(() async {
        executionOrder.add(3);
        await Future.delayed(const Duration(milliseconds: 30));
        executionOrder.add(4);
      });

      await Future.wait([future1, future2]);

      expect(executionOrder, equals([1, 2, 3, 4]));
    });

    test('handles errors in commands', () async {
      final serializer = AppPlayerCommandSerializer();
      final executionOrder = <int>[];

      final future1 = serializer.run(() async {
        executionOrder.add(1);
        throw Exception('Test error');
      });

      final future2 = serializer.run(() async {
        executionOrder.add(2);
      });

      await expectLater(future1, throwsException);
      await future2;

      expect(executionOrder, contains(1));
      expect(executionOrder, contains(2));
    });

    test('continues after error', () async {
      final serializer = AppPlayerCommandSerializer();
      var errorCaught = false;

      final future1 = serializer.run(() async {
        throw Exception('Test error');
      });

      final future2 = serializer.run(() async {
        return 'completed';
      });

      try {
        await future1;
      } catch (_) {
        errorCaught = true;
      }

      final result = await future2;
      expect(result, equals('completed'));
      expect(errorCaught, isTrue);
    });

    test('returns value from async action', () async {
      final serializer = AppPlayerCommandSerializer();

      final result = await serializer.run(() async {
        return 42;
      });

      expect(result, equals(42));
    });
  });
}
