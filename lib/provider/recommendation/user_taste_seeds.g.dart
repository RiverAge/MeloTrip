// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_taste_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for aggregated user taste seeds.
///
/// P1-A: Currently only aggregates favorite weighted seeds.
///
/// Future P1-B/P1-C may add:
/// - Current playing song (for context recommendations only)
/// - Play history seeds
/// - Rating seeds
///
/// The provider:
/// 1. Aggregates seeds from multiple sources (currently only favorites)
/// 2. Deduplicates by songId, keeping highest weight
/// 3. Sorts by weight descending
///
/// Returns empty list if no seeds are available.

@ProviderFor(userTasteSeeds)
final userTasteSeedsProvider = UserTasteSeedsProvider._();

/// Provider for aggregated user taste seeds.
///
/// P1-A: Currently only aggregates favorite weighted seeds.
///
/// Future P1-B/P1-C may add:
/// - Current playing song (for context recommendations only)
/// - Play history seeds
/// - Rating seeds
///
/// The provider:
/// 1. Aggregates seeds from multiple sources (currently only favorites)
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
  /// P1-A: Currently only aggregates favorite weighted seeds.
  ///
  /// Future P1-B/P1-C may add:
  /// - Current playing song (for context recommendations only)
  /// - Play history seeds
  /// - Rating seeds
  ///
  /// The provider:
  /// 1. Aggregates seeds from multiple sources (currently only favorites)
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

String _$userTasteSeedsHash() => r'5e8df15b54be7f0ed013adf7ff843398f252a5a9';
