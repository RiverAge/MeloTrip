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

String _$songFavoriteHash() => r'18770ed6e98e3041394763c7dc57d1486535b25e';

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

String _$songRatingHash() => r'261f78bb09176eb54c5ffa18de8344744f37b776';

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
