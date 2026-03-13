import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

void main() {
  test('returns null when index is out of range', () {
    final offset = computePlayQueueJumpOffset(
      index: 2,
      songCount: 2,
      maxScrollExtent: 500,
    );

    expect(offset, isNull);
  });

  test('returns zero when max extent is smaller than edge padding', () {
    final offset = computePlayQueueJumpOffset(
      index: 1,
      songCount: 3,
      maxScrollExtent: 10,
    );

    expect(offset, 0);
  });

  test('clamps to max safe offset when target exceeds extent', () {
    final offset = computePlayQueueJumpOffset(
      index: 10,
      songCount: 20,
      maxScrollExtent: 100,
    );

    expect(offset, 77);
  });

  test('returns target offset when within extent', () {
    final offset = computePlayQueueJumpOffset(
      index: 1,
      songCount: 3,
      maxScrollExtent: 500,
    );

    expect(offset, 72);
  });
}
