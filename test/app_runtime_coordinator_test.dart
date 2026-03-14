import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_logic/runtime/app_runtime_coordinator.dart';
import 'package:melo_trip/app_logic/runtime/desktop_lyrics_runtime.dart';
import 'package:melo_trip/app_logic/runtime/player_media_resolver_runtime.dart';
import 'package:melo_trip/app_logic/runtime/player_preferences_runtime.dart';
import 'package:melo_trip/app_logic/runtime/player_scrobble_runtime.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/provider/app/error.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:media_kit/media_kit.dart';

Future<WidgetRef> _pumpRef(
  WidgetTester tester, {
  List<Override> overrides = const <Override>[],
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

class _FakeMediaResolverRuntime extends PlayerMediaResolverRuntime {
  int attachCalls = 0;

  @override
  Future<void> attach(WidgetRef ref) async {
    attachCalls++;
  }
}

class _FakePlayerPreferencesRuntime extends PlayerPreferencesRuntime {
  int attachCalls = 0;

  @override
  Future<PlayerPreferencesRuntimeBindings> attach(WidgetRef ref) async {
    attachCalls++;
    return PlayerPreferencesRuntimeBindings(
      playlistModeSubscription: Stream<PlaylistMode>.empty().listen((_) {}),
      shuffleSubscription: Stream<bool>.empty().listen((_) {}),
    );
  }
}

class _FakeScrobbleRuntime extends PlayerScrobbleRuntime {
  int attachCalls = 0;

  @override
  Future<PlayerScrobbleRuntimeBindings?> attach(WidgetRef ref) async {
    attachCalls++;
    return PlayerScrobbleRuntimeBindings(
      subscription: Stream<(PlayQueue, bool)>.empty().listen((_) {}),
      cancelTimer: () {},
    );
  }
}

class _FakeDesktopLyricsRuntime extends DesktopLyricsRuntime {
  int attachCalls = 0;

  @override
  Future<DesktopLyricsRuntimeBindings?> attach(WidgetRef ref) async {
    attachCalls++;
    return DesktopLyricsRuntimeBindings(
      playQueueSubscription: Stream<PlayQueue>.empty().listen((_) {}),
      positionSubscription: Stream<Duration>.empty().listen((_) {}),
    );
  }
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'runtime coordinator starts runtimes and desktop bindings on desktop',
    (tester) async {
      final mediaResolverRuntime = _FakeMediaResolverRuntime();
      final playerPreferencesRuntime = _FakePlayerPreferencesRuntime();
      final scrobbleRuntime = _FakeScrobbleRuntime();
      final desktopLyricsRuntime = _FakeDesktopLyricsRuntime();
      final errorController = StreamController<String>.broadcast();
      addTearDown(errorController.close);

      final ref = await _pumpRef(
        tester,
        overrides: [
          playerMediaResolverRuntimeProvider.overrideWithValue(
            mediaResolverRuntime,
          ),
          playerPreferencesRuntimeProvider.overrideWithValue(
            playerPreferencesRuntime,
          ),
          playerScrobbleRuntimeProvider.overrideWithValue(scrobbleRuntime),
          desktopLyricsRuntimeProvider.overrideWithValue(desktopLyricsRuntime),
          appPlayerHandlerProvider.overrideWith(
            () => _FakeAppPlayerHandler(_FakeAppPlayer()),
          ),
          appRuntimeCoordinatorProvider.overrideWithValue(
            AppRuntimeCoordinator(
              resolvePlayerErrorStream: (_) => errorController.stream,
            ),
          ),
        ],
      );

      final bindings = await ref.read(appRuntimeCoordinatorProvider).start(ref);
      addTearDown(bindings.cancel);

      expect(mediaResolverRuntime.attachCalls, 1);
      expect(playerPreferencesRuntime.attachCalls, 1);
      expect(scrobbleRuntime.attachCalls, 1);
      expect(desktopLyricsRuntime.attachCalls, 1);
    },
    variant: const TargetPlatformVariant(<TargetPlatform>{TargetPlatform.windows}),
  );

  testWidgets('runtime coordinator forwards player errors to app error bus', (
    tester,
  ) async {
    final errorController = StreamController<String>.broadcast();
    addTearDown(errorController.close);

    final ref = await _pumpRef(
      tester,
      overrides: [
        playerMediaResolverRuntimeProvider.overrideWithValue(
          _FakeMediaResolverRuntime(),
        ),
        playerPreferencesRuntimeProvider.overrideWithValue(
          _FakePlayerPreferencesRuntime(),
        ),
        playerScrobbleRuntimeProvider.overrideWithValue(_FakeScrobbleRuntime()),
        desktopLyricsRuntimeProvider.overrideWithValue(_FakeDesktopLyricsRuntime()),
        appPlayerHandlerProvider.overrideWith(
          () => _FakeAppPlayerHandler(_FakeAppPlayer()),
        ),
        appRuntimeCoordinatorProvider.overrideWithValue(
          AppRuntimeCoordinator(
            resolvePlayerErrorStream: (_) => errorController.stream,
          ),
        ),
      ],
    );

    final bindings = await ref.read(appRuntimeCoordinatorProvider).start(ref);
    addTearDown(bindings.cancel);

    errorController.add('runtime boom');
    await tester.pump();

    final event = ref.read(appErrorProvider);
    expect(event?.message, 'runtime boom');
  });
}
