// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_weighted_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for favorite songs as weighted recommendation seeds.
///
/// Reads from favoriteRecommendationSeedsProvider and converts each
/// favorite song ID to a WeightedSeed with:
/// - source: SeedSource.favorite
/// - weight: 1.0 (highest priority)
/// - reason: 'favorite'
/// - timestamp: null
///
/// Returns empty list if favoriteRecommendationSeedsProvider returns empty.
/// Does not throw exceptions - inherits the graceful degradation from
/// favoriteRecommendationSeedsProvider.
///
/// Does NOT directly read favoriteProvider - reuses the existing
/// favoriteRecommendationSeedsProvider to avoid duplicating P0 logic.

@ProviderFor(favoriteWeightedSeeds)
final favoriteWeightedSeedsProvider = FavoriteWeightedSeedsProvider._();

/// Provider for favorite songs as weighted recommendation seeds.
///
/// Reads from favoriteRecommendationSeedsProvider and converts each
/// favorite song ID to a WeightedSeed with:
/// - source: SeedSource.favorite
/// - weight: 1.0 (highest priority)
/// - reason: 'favorite'
/// - timestamp: null
///
/// Returns empty list if favoriteRecommendationSeedsProvider returns empty.
/// Does not throw exceptions - inherits the graceful degradation from
/// favoriteRecommendationSeedsProvider.
///
/// Does NOT directly read favoriteProvider - reuses the existing
/// favoriteRecommendationSeedsProvider to avoid duplicating P0 logic.

final class FavoriteWeightedSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedSeed>>,
          List<WeightedSeed>,
          FutureOr<List<WeightedSeed>>
        >
    with
        $FutureModifier<List<WeightedSeed>>,
        $FutureProvider<List<WeightedSeed>> {
  /// Provider for favorite songs as weighted recommendation seeds.
  ///
  /// Reads from favoriteRecommendationSeedsProvider and converts each
  /// favorite song ID to a WeightedSeed with:
  /// - source: SeedSource.favorite
  /// - weight: 1.0 (highest priority)
  /// - reason: 'favorite'
  /// - timestamp: null
  ///
  /// Returns empty list if favoriteRecommendationSeedsProvider returns empty.
  /// Does not throw exceptions - inherits the graceful degradation from
  /// favoriteRecommendationSeedsProvider.
  ///
  /// Does NOT directly read favoriteProvider - reuses the existing
  /// favoriteRecommendationSeedsProvider to avoid duplicating P0 logic.
  FavoriteWeightedSeedsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteWeightedSeedsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteWeightedSeedsHash();

  @$internal
  @override
  $FutureProviderElement<List<WeightedSeed>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightedSeed>> create(Ref ref) {
    return favoriteWeightedSeeds(ref);
  }
}

String _$favoriteWeightedSeedsHash() =>
    r'abeda43da97651ae4e82e2459c91353bb19d3a29';
