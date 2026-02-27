import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/route/route_observer.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';

import 'test_helpers.dart';

void main() {
  test('routeObserverProvider returns a route observer', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final observer = container.read(routeObserverProvider);
    expect(observer, isA<RouteObserver<ModalRoute<void>>>());
  });

  test('albumsProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(albumsProvider(.newest).future);
    expect(result, isNull);
  });

  test('albumsProvider parses album list payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiAlbumList.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(albumsProvider(.newest).future);
    final albums = result?.subsonicResponse?.albumList?.album;
    expect(albums, isNotNull);
    expect(albums!.length, 1);
    expect(albums.first.name, 'Test Album');
  });

  test('scanStatusProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result, isNull);
  });

  test('scanStatusProvider parses status payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiScanStatus.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result?.subsonicResponse?.status, 'ok');
    expect(result?.subsonicResponse?.version, '1.2.3');
  });
}
