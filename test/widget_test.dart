import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/pages/home/home_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/route/route_observer.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';

void main() {
  testWidgets('Localization delegates load', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SizedBox.shrink(),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('Home keeps recommendation placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          albumsProvider(
            AlumsType.newest,
          ).overrideWith((_) async => null),
          albumsProvider(
            AlumsType.recent,
          ).overrideWith((_) async => null),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your daily mix of music is ready. Tap to explore personalized suggestions.',
      ),
      findsOneWidget,
    );
  });

  test('routeObserverProvider returns a route observer', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final observer = container.read(routeObserverProvider);
    expect(observer, isA<RouteObserver<ModalRoute<void>>>());
  });

  test('Supported locales include en and zh_CN', () {
    final locales = AppLocalizations.supportedLocales;
    expect(locales, contains(const Locale('en')));
    expect(locales, contains(const Locale('zh', 'CN')));
  });

  testWidgets('Home localization keys exist in en and zh_CN', (
    WidgetTester tester,
  ) async {
    String? enListenNow;
    String? zhListenNow;
    String? enGuessYouLike;
    String? zhGuessYouLike;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            enListenNow = l10n.listenNow;
            enGuessYouLike = l10n.guessYouLike;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            zhListenNow = l10n.listenNow;
            zhGuessYouLike = l10n.guessYouLike;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(enListenNow, isNotEmpty);
    expect(zhListenNow, isNotEmpty);
    expect(enGuessYouLike, isNotEmpty);
    expect(zhGuessYouLike, isNotEmpty);
  });

  testWidgets('InitialPage routes to LoginPage when user is not logged in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPlayerHandlerProvider.overrideWith(_FakeAppPlayerHandler.new),
          currentUserProvider.overrideWith(_FakeCurrentUser.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const InitialPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  test('albumsProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(_FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(albumsProvider(AlumsType.newest).future);
    expect(result, isNull);
  });

  test('albumsProvider parses album list payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(_FakeApiAlbumList.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(albumsProvider(AlumsType.newest).future);
    final albums = result?.subsonicResponse?.albumList?.album;
    expect(albums, isNotNull);
    expect(albums!.length, 1);
    expect(albums.first.name, 'Test Album');
  });

  test('scanStatusProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(_FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result, isNull);
  });

  test('scanStatusProvider parses status payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(_FakeApiScanStatus.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result?.subsonicResponse?.status, 'ok');
    expect(result?.subsonicResponse?.version, '1.2.3');
  });
}

class _FakeAppPlayerHandler extends AppPlayerHandler {
  @override
  Future<AppPlayer?> build() async => null;
}

class _FakeCurrentUser extends CurrentUser {
  @override
  Future<AuthUser?> build() async => null;
}

class _FakeApiNull extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = _StaticJsonAdapter(null);
    return dio;
  }
}

class _FakeApiAlbumList extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = _StaticJsonAdapter({
      'subsonic-response': {
        'status': 'ok',
        'albumList': {
          'album': [
            {'id': '1', 'name': 'Test Album', 'artist': 'Tester'},
          ],
        },
      },
    });
    return dio;
  }
}

class _FakeApiScanStatus extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = _StaticJsonAdapter({
      'subsonic-response': {
        'status': 'ok',
        'version': '1.2.3',
      },
    });
    return dio;
  }
}


class _StaticJsonAdapter implements HttpClientAdapter {
  _StaticJsonAdapter(this.json);

  final Map<String, dynamic>? json;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final payload = json == null ? 'null' : jsonEncode(json);
    return ResponseBody.fromBytes(
      utf8.encode(payload),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}
