// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumDetail)
final albumDetailProvider = AlbumDetailFamily._();

final class AlbumDetailProvider
    extends $AsyncNotifierProvider<AlbumDetail, SubsonicResponse?> {
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
  AlbumDetail create() => AlbumDetail();

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumDetailHash() => r'22b23a2ab54ac04ffffcda94d66173ca468264cf';

final class AlbumDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumDetail,
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>,
          String?
        > {
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

abstract class _$AlbumDetail extends $AsyncNotifier<SubsonicResponse?> {
  late final _$args = ref.$arg as String?;
  String? get albumId => _$args;

  FutureOr<SubsonicResponse?> build(String? albumId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(albumDetailResult)
final albumDetailResultProvider = AlbumDetailResultFamily._();

final class AlbumDetailResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  AlbumDetailResultProvider._({
    required AlbumDetailResultFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'albumDetailResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumDetailResultHash();

  @override
  String toString() {
    return r'albumDetailResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>?> create(Ref ref) {
    final argument = this.argument as String?;
    return albumDetailResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumDetailResultHash() => r'a37e4a2e55a8a961c17c498ba9b60df838cb5d88';

final class AlbumDetailResultFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  AlbumDetailResultFamily._()
    : super(
        retry: null,
        name: r'albumDetailResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumDetailResultProvider call(String? albumId) =>
      AlbumDetailResultProvider._(argument: albumId, from: this);

  @override
  String toString() => r'albumDetailResultProvider';
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

String _$albumFavoriteHash() => r'ba1cd629d21eabf254373328e1bfaebdf7a8d3c6';

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

String _$albumRatingHash() => r'd6a77bcc7a4900d28408cd3b2fed9eb88e52759f';

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
