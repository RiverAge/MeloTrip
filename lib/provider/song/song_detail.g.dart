// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(songDetail)
final songDetailProvider = SongDetailFamily._();

final class SongDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
  SongDetailProvider._({
    required SongDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'songDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$songDetailHash();

  @override
  String toString() {
    return r'songDetailProvider'
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
    return songDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SongDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songDetailHash() => r'53603006eb5e37899f99463f2bd5a829ec0e27df';

final class SongDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, String?> {
  SongDetailFamily._()
    : super(
        retry: null,
        name: r'songDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SongDetailProvider call(String? songId) =>
      SongDetailProvider._(argument: songId, from: this);

  @override
  String toString() => r'songDetailProvider';
}

@ProviderFor(songDetailResult)
final songDetailResultProvider = SongDetailResultFamily._();

final class SongDetailResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  SongDetailResultProvider._({
    required SongDetailResultFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'songDetailResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$songDetailResultHash();

  @override
  String toString() {
    return r'songDetailResultProvider'
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
    return songDetailResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SongDetailResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songDetailResultHash() => r'a8ba1bcaf5d372e39232d9c7781de9f5fe922f5b';

final class SongDetailResultFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  SongDetailResultFamily._()
    : super(
        retry: null,
        name: r'songDetailResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SongDetailResultProvider call(String? songId) =>
      SongDetailResultProvider._(argument: songId, from: this);

  @override
  String toString() => r'songDetailResultProvider';
}

@ProviderFor(SongFavorite)
final songFavoriteProvider = SongFavoriteProvider._();

final class SongFavoriteProvider
    extends $AsyncNotifierProvider<SongFavorite, SubsonicResponse?> {
  SongFavoriteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'songFavoriteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$songFavoriteHash();

  @$internal
  @override
  SongFavorite create() => SongFavorite();
}

String _$songFavoriteHash() => r'2600446ccc61b84b9b4c4743d33f06f1030597b4';

abstract class _$SongFavorite extends $AsyncNotifier<SubsonicResponse?> {
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

@ProviderFor(SongRating)
final songRatingProvider = SongRatingProvider._();

final class SongRatingProvider
    extends $AsyncNotifierProvider<SongRating, SubsonicResponse?> {
  SongRatingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'songRatingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$songRatingHash();

  @$internal
  @override
  SongRating create() => SongRating();
}

String _$songRatingHash() => r'5006543fe9ab863bdf0522925c1be655cb381d36';

abstract class _$SongRating extends $AsyncNotifier<SubsonicResponse?> {
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
