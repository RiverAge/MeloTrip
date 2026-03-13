import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
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

class _RecordingMediaKitPlayer {
  int openCalls = 0;
  dynamic lastPlaylist;
  bool? lastPlay;

  Future<void> open(dynamic playlist, {bool play = true}) async {
    openCalls++;
    lastPlaylist = playlist;
    lastPlay = play;
  }
}

class _RecordingAppPlayer implements AppPlayer {
  _RecordingAppPlayer({this.onSerialized});

  final Future<void> Function()? onSerialized;

  final List<SongEntity> resolvedSongs = <SongEntity>[];
  final _RecordingMediaKitPlayer mediaPlayer = _RecordingMediaKitPlayer();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    if (memberName == 'Symbol("_runSerialized")') {
      return Future<void>.sync(() async {
        await onSerialized?.call();
        final action = invocation.positionalArguments.first as Function;
        return await Function.apply(action, const <Object?>[]);
      });
    }
    if (memberName == 'Symbol("_mediaResolver")') {
      return (SongEntity song) async {
        resolvedSongs.add(song);
        return Media(song.id ?? '');
      };
    }
    if (memberName == 'Symbol("_player")') {
      return mediaPlayer;
    }
    return super.noSuchMethod(invocation);
  }
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
  List overrides = const [],
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

  testWidgets('restores play queue into player once for the same user', (
    tester,
  ) async {
    final player = _RecordingAppPlayer();
    final songs = <SongEntity>[_song('s1'), _song('s2')];
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
          (ref) async => _queueResponse(songs: songs, current: 's2'),
        ),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(player),
        ),
      ],
    );

    await ensurePlayQueueRestored(ref);
    await ensurePlayQueueRestored(ref);

    expect(player.mediaPlayer.openCalls, 1);
    expect(player.resolvedSongs.map((song) => song.id), <String?>['s1', 's2']);
    expect((player.mediaPlayer.lastPlaylist as dynamic).index, 1);
    expect(player.mediaPlayer.lastPlay, isFalse);
  });

  testWidgets('concurrent restore calls share the same in-flight work', (
    tester,
  ) async {
    final gate = Completer<void>();
    final player = _RecordingAppPlayer(onSerialized: () => gate.future);
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
          () => _FakeAppPlayerHandler(player),
        ),
      ],
    );

    final first = ensurePlayQueueRestored(ref);
    final second = ensurePlayQueueRestored(ref);
    await tester.pump();
    expect(player.mediaPlayer.openCalls, 0);

    gate.complete();
    await Future.wait(<Future<void>>[first, second]);

    expect(player.mediaPlayer.openCalls, 1);
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
    final player = _RecordingAppPlayer();
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
          () => _FakeAppPlayerHandler(player),
        ),
      ],
    );

    await ensurePlayQueueRestored(ref);
    resetPlayQueueRestoreStateForTest();
    await ensurePlayQueueRestored(ref);

    expect(player.mediaPlayer.openCalls, 2);
  });
}
