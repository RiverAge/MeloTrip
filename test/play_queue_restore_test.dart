import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_logic/restore/play_queue_restore.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/play_queue/play_queue.dart';

class _FakeCurrentUser extends CurrentUser {
  _FakeCurrentUser(this._user);

  final AuthUser? _user;

  @override
  Future<AuthUser?> build() async => _user;
}

class _FakeAppPlayerHandler extends AppPlayerHandler {
  _FakeAppPlayerHandler(this._player);

  final AppPlayer? _player;

  @override
  Future<AppPlayer?> build() async => _player;
}

class _FakeAppPlayer implements AppPlayer {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ExplodingCurrentUser extends CurrentUser {
  @override
  Future<AuthUser?> build() async => throw StateError('boom');
}

SongEntity _song(String id) {
  return SongEntity(
    id: id,
    title: 'Song $id',
    artist: 'Tester',
    duration: 120,
    track: 1,
    discNumber: 1,
  );
}

SubsonicResponse _queueResponse({
  required List<SongEntity> songs,
  String? current,
}) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      playQueue: PlayQueueEntity(entry: songs, current: current),
    ),
  );
}

Future<WidgetRef> _pumpRef(
  WidgetTester tester, {
  List<Object> overrides = const <Object>[],
}) async {
  final completer = Completer<WidgetRef>();
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides.cast(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Consumer(
          builder: (context, ref, _) {
            if (!completer.isCompleted) {
              completer.complete(ref);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  await tester.pump();
  return completer.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(resetPlayQueueRestoreStateForTest);

  testWidgets('restores play queue once for the same user session', (tester) async {
    var authLoads = 0;
    var queueLoads = 0;
    List<SongEntity>? restoredSongs;
    String? restoredInitialId;
    final songs = <SongEntity>[_song('s1'), _song('s2')];
    final ref = await _pumpRef(
      tester,
      overrides: [
        currentUserProvider.overrideWith(() {
          authLoads++;
          return _FakeCurrentUser(
            const AuthUser(
              host: 'https://example.com',
              username: 'tester',
              token: 'token',
            ),
          );
        }),
        playQueueProvider.overrideWith((ref) async {
          queueLoads++;
          return _queueResponse(songs: songs, current: 's2');
        }),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(_FakeAppPlayer()),
        ),
      ],
    );

    Future<void> applyQueue(
      AppPlayer player,
      List<SongEntity> songs,
      String? initialId,
    ) async {
      restoredSongs = songs;
      restoredInitialId = initialId;
    }

    await ensurePlayQueueRestored(ref, applyRestoredPlayQueue: applyQueue);
    await ensurePlayQueueRestored(ref, applyRestoredPlayQueue: applyQueue);

    expect(authLoads, 1);
    expect(queueLoads, 1);
    expect(restoredSongs?.map((song) => song.id), <String?>['s1', 's2']);
    expect(restoredInitialId, 's2');
  });

  testWidgets('concurrent restore calls reuse the same in-flight work', (
    tester,
  ) async {
    var authLoads = 0;
    var queueLoads = 0;
    var applyCalls = 0;
    final applyGate = Completer<void>();
    final ref = await _pumpRef(
      tester,
      overrides: [
        currentUserProvider.overrideWith(() {
          authLoads++;
          return _FakeCurrentUser(
            const AuthUser(
              host: 'https://example.com',
              username: 'tester',
              token: 'token',
            ),
          );
        }),
        playQueueProvider.overrideWith((ref) async {
          queueLoads++;
          return _queueResponse(songs: <SongEntity>[_song('s1')]);
        }),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(_FakeAppPlayer()),
        ),
      ],
    );

    Future<void> applyQueue(
      AppPlayer player,
      List<SongEntity> songs,
      String? initialId,
    ) async {
      applyCalls++;
      await applyGate.future;
    }

    final first = ensurePlayQueueRestored(
      ref,
      applyRestoredPlayQueue: applyQueue,
    );
    final second = ensurePlayQueueRestored(
      ref,
      applyRestoredPlayQueue: applyQueue,
    );
    await tester.pump();

    expect(authLoads, 1);
    expect(queueLoads, 1);
    expect(applyCalls, 1);

    applyGate.complete();
    await Future.wait(<Future<void>>[first, second]);

    expect(authLoads, 1);
    expect(queueLoads, 1);
    expect(applyCalls, 1);
  });

  testWidgets('restore safely returns when player is unavailable', (tester) async {
    final ref = await _pumpRef(
      tester,
      overrides: [
        currentUserProvider.overrideWith(
          () => _FakeCurrentUser(
            const AuthUser(
              host: 'https://example.com',
              username: 'tester',
              token: 'token',
            ),
          ),
        ),
        playQueueProvider.overrideWith(
          (ref) async => _queueResponse(songs: <SongEntity>[_song('s1')]),
        ),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(null),
        ),
      ],
    );

    await expectLater(ensurePlayQueueRestored(ref), completes);
  });

  testWidgets('restore swallows provider failures to keep UI resilient', (
    tester,
  ) async {
    final ref = await _pumpRef(
      tester,
      overrides: [
        currentUserProvider.overrideWith(_ExplodingCurrentUser.new),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(null),
        ),
      ],
    );

    await expectLater(ensurePlayQueueRestored(ref), completes);
  });

  testWidgets('reset helper clears cached restore state', (tester) async {
    var applyCalls = 0;
    final ref = await _pumpRef(
      tester,
      overrides: [
        currentUserProvider.overrideWith(
          () => _FakeCurrentUser(
            const AuthUser(
              host: 'https://example.com',
              username: 'tester',
              token: 'token',
            ),
          ),
        ),
        playQueueProvider.overrideWith((ref) async {
          return _queueResponse(songs: <SongEntity>[_song('s1')]);
        }),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(_FakeAppPlayer()),
        ),
      ],
    );

    Future<void> applyQueue(
      AppPlayer player,
      List<SongEntity> songs,
      String? initialId,
    ) async {
      applyCalls++;
    }

    await ensurePlayQueueRestored(ref, applyRestoredPlayQueue: applyQueue);
    resetPlayQueueRestoreStateForTest();
    await ensurePlayQueueRestored(ref, applyRestoredPlayQueue: applyQueue);

    expect(applyCalls, 2);
  });
}
