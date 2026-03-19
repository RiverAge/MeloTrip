import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/route_observer.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';

import 'test_helpers.dart';

void main() {
  test('routeObserverProvider returns a route observer', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final observer = container.read(routeObserverProvider);
    expect(observer, isA<RouteObserver<ModalRoute<void>>>());
  });

  test('albumListProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      albumListProvider(AlbumListQuery(type: AlbumListType.newest.name)).future,
    );
    expect(result.isErr, isTrue);
  });

  test('albumListProvider parses album list payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiAlbumList.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      albumListProvider(AlbumListQuery(type: AlbumListType.newest.name)).future,
    );
    expect(result.isOk, isTrue);
    final albums = result.data!;
    expect(albums.length, 1);
    expect(albums.first.name, 'Test Album');
  });

  test('scanStatusProvider handles null API payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiNull.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result.isErr, isTrue);
  });

  test('scanStatusProvider parses status payload', () async {
    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(FakeApiScanStatus.new)],
    );
    addTearDown(container.dispose);

    final result = await container.read(scanStatusProvider.future);
    expect(result.isOk, isTrue);
    expect(result.data?.subsonicResponse?.status, 'ok');
    expect(result.data?.subsonicResponse?.version, '1.2.3');
  });
}

