import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/command_serializer.dart';

void main() {
  test('serializes overlapping commands in submission order', () async {
    final serializer = AppPlayerCommandSerializer();
    final timeline = <String>[];
    final firstGate = Completer<void>();

    final first = serializer.run(() async {
      timeline.add('first:start');
      await firstGate.future;
      timeline.add('first:end');
      return 1;
    });

    final second = serializer.run(() async {
      timeline.add('second:start');
      timeline.add('second:end');
      return 2;
    });

    await Future<void>.delayed(Duration.zero);
    expect(timeline, ['first:start']);

    firstGate.complete();
    final results = await Future.wait([first, second]);

    expect(results, [1, 2]);
    expect(timeline, [
      'first:start',
      'first:end',
      'second:start',
      'second:end',
    ]);
  });

  test('continues processing later commands after an error', () async {
    final serializer = AppPlayerCommandSerializer();
    final timeline = <String>[];

    final first = serializer.run<int>(() async {
      timeline.add('first');
      throw StateError('boom');
    });

    final second = serializer.run<int>(() async {
      timeline.add('second');
      return 2;
    });

    await expectLater(first, throwsA(isA<StateError>()));
    await expectLater(second, completion(2));
    expect(timeline, ['first', 'second']);
  });
}
