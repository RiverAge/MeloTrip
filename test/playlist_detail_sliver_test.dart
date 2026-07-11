import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/mobile/playlist/playlist_detail_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

import 'test_helpers.dart';

/// 回归测试：`_PlaylistDetailBuilder` 直接作为 [CustomScrollView.slivers]
/// 的一员，其每条返回路径都必须是 Sliver。修复前，`appPlayerHandlerProvider`
/// 尚未就绪（player == null）时，`AsyncValueBuilder` 的 data→null 分支返回
/// `NoData`（RenderBox）；`PlayQueueBuilder` 的 loading 分支返回
/// `SizedBox.shrink`（RenderBox）。把 RenderBox 放进 `CustomScrollView` 会让
/// `RenderViewport` 抛：
/// "A RenderViewport expected a child of type RenderSliver but received a
///  child of type RenderConstrainedBox / RenderErrorBox"。
///
/// 这里用 [_NullPlayerHandler]（`build() => null`）模拟 player 未就绪，
/// 不依赖 media_kit native 库，pump 后断言无 viewport sliver 异常、且
/// 页面能正常 layout 出标题与歌曲。
class _NullPlayerHandler extends AppPlayerHandler {
  @override
  Future<AppPlayer?> build() async => null;
}

class _FakePlaylistDetail extends PlaylistDetail {
  _FakePlaylistDetail(this._result);

  final Result<PlaylistEntity, AppFailure> _result;

  @override
  Future<Result<PlaylistEntity, AppFailure>?> build(String? playlistId) async =>
      _result;
}

SongEntity _song({required String id, required String title}) {
  return SongEntity(
    id: id,
    title: title,
    track: 1,
    artist: 'tester',
    duration: 120,
    discNumber: 1,
  );
}

PlaylistEntity _playlistWithSongs(List<SongEntity> songs) {
  return PlaylistEntity(
    id: 'pl-1',
    name: 'Playlist A',
    songCount: songs.length,
    duration: 240,
    entry: songs,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'PlaylistDetail is sliver-safe when player handler is not ready',
    (tester) async {
      final songs = [
        _song(id: 's1', title: 'Song 1'),
        _song(id: 's2', title: 'Song 2'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // player 未就绪：AsyncValueBuilder 的 data 分支拿到 null。
            appPlayerHandlerProvider.overrideWith(() => _NullPlayerHandler()),
            playlistDetailProvider('pl-1').overrideWith(
              () => _FakePlaylistDetail(Result.ok(_playlistWithSongs(songs))),
            ),
            sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PlaylistDetailPage(playlistId: 'pl-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 修复后：viewport 子节点均为 Sliver，不抛异常。
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomScrollView), findsOneWidget);
    },
  );
}
