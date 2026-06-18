// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_recommendation_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for extracting recommendation seeds from favorite songs.
///
/// Reads from favoriteProvider and extracts song IDs to use as seeds
/// for the recommendations system.
///
/// - Returns empty list if favoriteProvider returns error or no songs.
/// - Does NOT read play history or ratings.
/// - Does NOT write to database.

@ProviderFor(favoriteRecommendationSeeds)
final favoriteRecommendationSeedsProvider =
    FavoriteRecommendationSeedsFamily._();

/// Provider for extracting recommendation seeds from favorite songs.
///
/// Reads from favoriteProvider and extracts song IDs to use as seeds
/// for the recommendations system.
///
/// - Returns empty list if favoriteProvider returns error or no songs.
/// - Does NOT read play history or ratings.
/// - Does NOT write to database.

final class FavoriteRecommendationSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Provider for extracting recommendation seeds from favorite songs.
  ///
  /// Reads from favoriteProvider and extracts song IDs to use as seeds
  /// for the recommendations system.
  ///
  /// - Returns empty list if favoriteProvider returns error or no songs.
  /// - Does NOT read play history or ratings.
  /// - Does NOT write to database.
  FavoriteRecommendationSeedsProvider._({
    required FavoriteRecommendationSeedsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'favoriteRecommendationSeedsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteRecommendationSeedsHash();

  @override
  String toString() {
    return r'favoriteRecommendationSeedsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as int;
    return favoriteRecommendationSeeds(ref, maxSeeds: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteRecommendationSeedsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteRecommendationSeedsHash() =>
    r'e239f5e3faae5f1521f364890afc6db3e7a192c2';

/// Provider for extracting recommendation seeds from favorite songs.
///
/// Reads from favoriteProvider and extracts song IDs to use as seeds
/// for the recommendations system.
///
/// - Returns empty list if favoriteProvider returns error or no songs.
/// - Does NOT read play history or ratings.
/// - Does NOT write to database.

final class FavoriteRecommendationSeedsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, int> {
  FavoriteRecommendationSeedsFamily._()
    : super(
        retry: null,
        name: r'favoriteRecommendationSeedsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for extracting recommendation seeds from favorite songs.
  ///
  /// Reads from favoriteProvider and extracts song IDs to use as seeds
  /// for the recommendations system.
  ///
  /// - Returns empty list if favoriteProvider returns error or no songs.
  /// - Does NOT read play history or ratings.
  /// - Does NOT write to database.

  FavoriteRecommendationSeedsProvider call({int maxSeeds = 5}) =>
      FavoriteRecommendationSeedsProvider._(argument: maxSeeds, from: this);

  @override
  String toString() => r'favoriteRecommendationSeedsProvider';
}
