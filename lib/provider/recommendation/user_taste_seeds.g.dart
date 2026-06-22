// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_taste_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for aggregated user taste seeds.
///
/// Aggregates weighted seeds from available user taste signals.
///
/// Currently includes:
/// - Favorite songs
/// - Songs from favorite albums
/// - Songs from favorite artists
/// - Songs from user playlists
///
/// Future iterations may add:
/// - Current playing song (for context recommendations only)
/// - Play history seeds
/// - Rating seeds
///
/// The provider:
/// 1. Aggregates seeds from multiple sources
/// 2. Deduplicates by songId, keeping highest weight
/// 3. Sorts by weight descending
///
/// Returns empty list if no seeds are available.

@ProviderFor(userTasteSeeds)
final userTasteSeedsProvider = UserTasteSeedsProvider._();

/// Provider for aggregated user taste seeds.
///
/// Aggregates weighted seeds from available user taste signals.
///
/// Currently includes:
/// - Favorite songs
/// - Songs from favorite albums
/// - Songs from favorite artists
/// - Songs from user playlists
///
/// Future iterations may add:
/// - Current playing song (for context recommendations only)
/// - Play history seeds
/// - Rating seeds
///
/// The provider:
/// 1. Aggregates seeds from multiple sources
/// 2. Deduplicates by songId, keeping highest weight
/// 3. Sorts by weight descending
///
/// Returns empty list if no seeds are available.

final class UserTasteSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedSeed>>,
          List<WeightedSeed>,
          FutureOr<List<WeightedSeed>>
        >
    with
        $FutureModifier<List<WeightedSeed>>,
        $FutureProvider<List<WeightedSeed>> {
  /// Provider for aggregated user taste seeds.
  ///
  /// Aggregates weighted seeds from available user taste signals.
  ///
  /// Currently includes:
  /// - Favorite songs
  /// - Songs from favorite albums
  /// - Songs from favorite artists
  /// - Songs from user playlists
  ///
  /// Future iterations may add:
  /// - Current playing song (for context recommendations only)
  /// - Play history seeds
  /// - Rating seeds
  ///
  /// The provider:
  /// 1. Aggregates seeds from multiple sources
  /// 2. Deduplicates by songId, keeping highest weight
  /// 3. Sorts by weight descending
  ///
  /// Returns empty list if no seeds are available.
  UserTasteSeedsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userTasteSeedsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userTasteSeedsHash();

  @$internal
  @override
  $FutureProviderElement<List<WeightedSeed>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightedSeed>> create(Ref ref) {
    return userTasteSeeds(ref);
  }
}

String _$userTasteSeedsHash() => r'5df35df1ece752b0989d697aa0327314e0415f7c';
