import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

int _countPattern(String text, String pattern) {
  final regex = RegExp(pattern);
  return regex.allMatches(text).length;
}

String _readFile(String relativePath) {
  return File(relativePath).readAsStringSync();
}

void main() {
  test('music bar subscription count regression guard', () {
    final musicBar = _readFile(
      'lib/pages/mobile/music_bar/parts/music_bar.dart',
    );
    final bottomSheet = _readFile(
      'lib/pages/mobile/music_bar/parts/bottom_sheet_play_queue.dart',
    );

    expect(_countPattern(musicBar, 'appPlayerHandlerProvider'), 1);
    expect(_countPattern(musicBar, 'provider:\\s*player\\.playingStream'), 1);
    expect(_countPattern(bottomSheet, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(
        bottomSheet,
        'provider:\\s*widget\\.player\\.playingStream',
      ),
      1,
    );
  });

  test('list item pages avoid nested player provider reads', () {
    final albumListItem = _readFile(
      'lib/pages/mobile/album/parts/list_item.dart',
    );
    final playlistBuilder = _readFile(
      'lib/pages/mobile/playlist/parts/playlist_detail_builder.dart',
    );

    expect(_countPattern(albumListItem, 'appPlayerHandlerProvider'), 0);
    expect(_countPattern(albumListItem, 'playingStream'), 0);
    expect(_countPattern(playlistBuilder, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(playlistBuilder, 'provider:\\s*player\\.playingStream'),
      1,
    );
  });

  test('playing page subscription count regression guard', () {
    final musicControls = _readFile(
      'lib/pages/mobile/playing/parts/music_controls.dart',
    );
    final timerAxis = _readFile(
      'lib/pages/mobile/playing/parts/timer_axis.dart',
    );
    final playerControls = _readFile(
      'lib/pages/mobile/playing/parts/player_controls.dart',
    );

    expect(_countPattern(musicControls, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(musicControls, 'provider:\\s*player\\.playlistModeStream'),
      1,
    );
    expect(_countPattern(timerAxis, 'appPlayerHandlerProvider'), 1);
    expect(_countPattern(timerAxis, 'provider:\\s*player\\.durationStream'), 1);
    expect(_countPattern(playerControls, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(playerControls, 'provider:\\s*player\\.playingStream'),
      1,
    );
  });
}
