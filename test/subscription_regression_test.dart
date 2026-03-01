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
    final musicBar = _readFile('lib/pages/tab/music_bar/parts/music_bar.dart');
    final bottomSheet = _readFile(
      'lib/pages/tab/music_bar/parts/bottom_sheet_play_queue.dart',
    );

    expect(_countPattern(musicBar, 'appPlayerHandlerProvider'), 1);
    expect(_countPattern(musicBar, 'provider:\\s*player\\.playingStream'), 1);
    expect(_countPattern(bottomSheet, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(bottomSheet, 'provider:\\s*widget\\.player\\.playingStream'),
      1,
    );
  });

  test('list item pages avoid nested player provider reads', () {
    final albumListItem = _readFile('lib/pages/album/parts/list_item.dart');
    final playlistBuilder = _readFile(
      'lib/pages/playlist/parts/playlist_detail_builder.dart',
    );

    expect(_countPattern(albumListItem, 'appPlayerHandlerProvider'), 0);
    expect(_countPattern(albumListItem, 'playingStream'), 0);
    expect(_countPattern(playlistBuilder, 'appPlayerHandlerProvider'), 1);
    expect(
      _countPattern(playlistBuilder, 'provider:\\s*player\\.playingStream'),
      1,
    );
  });
}
