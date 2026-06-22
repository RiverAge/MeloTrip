// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_album_weighted_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteAlbumWeightedSeeds)
final favoriteAlbumWeightedSeedsProvider = FavoriteAlbumWeightedSeedsFamily._();

final class FavoriteAlbumWeightedSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedSeed>>,
          List<WeightedSeed>,
          FutureOr<List<WeightedSeed>>
        >
    with
        $FutureModifier<List<WeightedSeed>>,
        $FutureProvider<List<WeightedSeed>> {
  FavoriteAlbumWeightedSeedsProvider._({
    required FavoriteAlbumWeightedSeedsFamily super.from,
    required ({int maxAlbums, int maxSeeds}) super.argument,
  }) : super(
         retry: null,
         name: r'favoriteAlbumWeightedSeedsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteAlbumWeightedSeedsHash();

  @override
  String toString() {
    return r'favoriteAlbumWeightedSeedsProvider'
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
    final argument = this.argument as ({int maxAlbums, int maxSeeds});
    return favoriteAlbumWeightedSeeds(
      ref,
      maxAlbums: argument.maxAlbums,
      maxSeeds: argument.maxSeeds,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteAlbumWeightedSeedsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteAlbumWeightedSeedsHash() =>
    r'6f339f61ceb7128e883ce7b16c726603ad19e255';

final class FavoriteAlbumWeightedSeedsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WeightedSeed>>,
          ({int maxAlbums, int maxSeeds})
        > {
  FavoriteAlbumWeightedSeedsFamily._()
    : super(
        retry: null,
        name: r'favoriteAlbumWeightedSeedsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FavoriteAlbumWeightedSeedsProvider call({
    int maxAlbums = 3,
    int maxSeeds = 6,
  }) => FavoriteAlbumWeightedSeedsProvider._(
    argument: (maxAlbums: maxAlbums, maxSeeds: maxSeeds),
    from: this,
  );

  @override
  String toString() => r'favoriteAlbumWeightedSeedsProvider';
}
