// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'for_you_recommendations_v2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for "For You" recommendations (P1 version).
///
/// This is a parallel implementation kept for migration testing and validation.
/// It does NOT replace the existing forYouRecommendationsProvider.
///
/// The provider:
/// 1. Reads userTasteSeedsProvider
/// 2. Extracts song IDs from weighted seeds
/// 3. Calls recommendationsProvider with the seed IDs
///
/// Returns empty list if no seeds are available.
/// Does NOT fallback to getSimilarSongs2.
/// Does NOT call AudioMuse-AI API directly.
/// Does NOT cache results to local database.
///
/// This provider is NOT connected to the homepage UI.
/// It exists for parallel testing and future migration consideration.

@ProviderFor(forYouRecommendationsV2)
final forYouRecommendationsV2Provider = ForYouRecommendationsV2Provider._();

/// Provider for "For You" recommendations (P1 version).
///
/// This is a parallel implementation kept for migration testing and validation.
/// It does NOT replace the existing forYouRecommendationsProvider.
///
/// The provider:
/// 1. Reads userTasteSeedsProvider
/// 2. Extracts song IDs from weighted seeds
/// 3. Calls recommendationsProvider with the seed IDs
///
/// Returns empty list if no seeds are available.
/// Does NOT fallback to getSimilarSongs2.
/// Does NOT call AudioMuse-AI API directly.
/// Does NOT cache results to local database.
///
/// This provider is NOT connected to the homepage UI.
/// It exists for parallel testing and future migration consideration.

final class ForYouRecommendationsV2Provider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>
        >
    with $FutureModifier<List<SongEntity>>, $FutureProvider<List<SongEntity>> {
  /// Provider for "For You" recommendations (P1 version).
  ///
  /// This is a parallel implementation kept for migration testing and validation.
  /// It does NOT replace the existing forYouRecommendationsProvider.
  ///
  /// The provider:
  /// 1. Reads userTasteSeedsProvider
  /// 2. Extracts song IDs from weighted seeds
  /// 3. Calls recommendationsProvider with the seed IDs
  ///
  /// Returns empty list if no seeds are available.
  /// Does NOT fallback to getSimilarSongs2.
  /// Does NOT call AudioMuse-AI API directly.
  /// Does NOT cache results to local database.
  ///
  /// This provider is NOT connected to the homepage UI.
  /// It exists for parallel testing and future migration consideration.
  ForYouRecommendationsV2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forYouRecommendationsV2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forYouRecommendationsV2Hash();

  @$internal
  @override
  $FutureProviderElement<List<SongEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongEntity>> create(Ref ref) {
    return forYouRecommendationsV2(ref);
  }
}

String _$forYouRecommendationsV2Hash() =>
    r'51d33b5bd0651a0572dd42733f6bb01cfbd8a4b9';
