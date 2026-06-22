// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_artist_weighted_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteArtistWeightedSeeds)
final favoriteArtistWeightedSeedsProvider =
    FavoriteArtistWeightedSeedsFamily._();

final class FavoriteArtistWeightedSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedSeed>>,
          List<WeightedSeed>,
          FutureOr<List<WeightedSeed>>
        >
    with
        $FutureModifier<List<WeightedSeed>>,
        $FutureProvider<List<WeightedSeed>> {
  FavoriteArtistWeightedSeedsProvider._({
    required FavoriteArtistWeightedSeedsFamily super.from,
    required ({int maxArtists, int maxAlbumsPerArtist, int maxSeeds})
    super.argument,
  }) : super(
         retry: null,
         name: r'favoriteArtistWeightedSeedsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteArtistWeightedSeedsHash();

  @override
  String toString() {
    return r'favoriteArtistWeightedSeedsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeightedSeed>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightedSeed>> create(Ref ref) {
    final argument =
        this.argument
            as ({int maxArtists, int maxAlbumsPerArtist, int maxSeeds});
    return favoriteArtistWeightedSeeds(
      ref,
      maxArtists: argument.maxArtists,
      maxAlbumsPerArtist: argument.maxAlbumsPerArtist,
      maxSeeds: argument.maxSeeds,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteArtistWeightedSeedsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteArtistWeightedSeedsHash() =>
    r'b7344a0e5825a573f75bea8a25b9ab1175fb7816';

final class FavoriteArtistWeightedSeedsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WeightedSeed>>,
          ({int maxArtists, int maxAlbumsPerArtist, int maxSeeds})
        > {
  FavoriteArtistWeightedSeedsFamily._()
    : super(
        retry: null,
        name: r'favoriteArtistWeightedSeedsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FavoriteArtistWeightedSeedsProvider call({
    int maxArtists = 2,
    int maxAlbumsPerArtist = 2,
    int maxSeeds = 6,
  }) => FavoriteArtistWeightedSeedsProvider._(
    argument: (
      maxArtists: maxArtists,
      maxAlbumsPerArtist: maxAlbumsPerArtist,
      maxSeeds: maxSeeds,
    ),
    from: this,
  );

  @override
  String toString() => r'favoriteArtistWeightedSeedsProvider';
}
