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

String _$songDetailHash() => r'c1b5862c8fe072b93f0b07f671557b63cdd38c3d';

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

String _$songFavoriteHash() => r'4f67b8cfaf1c53f6de4e4bf5ab633263cfff1196';

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

String _$songRatingHash() => r'70a8c77d55220ed6ffda289c14ffa460a7c6c4cd';

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
