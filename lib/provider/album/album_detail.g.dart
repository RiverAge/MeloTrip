// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(albumDetail)
final albumDetailProvider = AlbumDetailFamily._();

final class AlbumDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
  AlbumDetailProvider._({
    required AlbumDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'albumDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumDetailHash();

  @override
  String toString() {
    return r'albumDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SubsonicResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubsonicResponse?> create(Ref ref) {
    final argument = this.argument as String?;
    return albumDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumDetailHash() => r'1a49a8ebce097d0c43a91f52503515248b53928d';

final class AlbumDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, String?> {
  AlbumDetailFamily._()
    : super(
        retry: null,
        name: r'albumDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumDetailProvider call(String? albumId) =>
      AlbumDetailProvider._(argument: albumId, from: this);

  @override
  String toString() => r'albumDetailProvider';
}

@ProviderFor(AlbumFavorite)
final albumFavoriteProvider = AlbumFavoriteProvider._();

final class AlbumFavoriteProvider
    extends $AsyncNotifierProvider<AlbumFavorite, SubsonicResponse?> {
  AlbumFavoriteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumFavoriteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumFavoriteHash();

  @$internal
  @override
  AlbumFavorite create() => AlbumFavorite();
}

String _$albumFavoriteHash() => r'022f115678d08b4ba73e84416ee70481a90c0efb';

abstract class _$AlbumFavorite extends $AsyncNotifier<SubsonicResponse?> {
  FutureOr<SubsonicResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubsonicResponse?>, SubsonicResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubsonicResponse?>, SubsonicResponse?>,
              AsyncValue<SubsonicResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AlbumRating)
final albumRatingProvider = AlbumRatingProvider._();

final class AlbumRatingProvider
    extends $AsyncNotifierProvider<AlbumRating, SubsonicResponse?> {
  AlbumRatingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumRatingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumRatingHash();

  @$internal
  @override
  AlbumRating create() => AlbumRating();
}

String _$albumRatingHash() => r'87ad72cd52da4ad3f28d4ef1b1f83eb729ad44d9';

abstract class _$AlbumRating extends $AsyncNotifier<SubsonicResponse?> {
  FutureOr<SubsonicResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubsonicResponse?>, SubsonicResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubsonicResponse?>, SubsonicResponse?>,
              AsyncValue<SubsonicResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
