// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'for_you_recommendations.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for "For You" recommendations on the home page.
///
/// Uses favorite songs as seeds and calls the existing recommendationsProvider
/// to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Does NOT cache results to local database.

@ProviderFor(forYouRecommendations)
final forYouRecommendationsProvider = ForYouRecommendationsProvider._();

/// Provider for "For You" recommendations on the home page.
///
/// Uses favorite songs as seeds and calls the existing recommendationsProvider
/// to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Does NOT cache results to local database.

final class ForYouRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>
        >
    with $FutureModifier<List<SongEntity>>, $FutureProvider<List<SongEntity>> {
  /// Provider for "For You" recommendations on the home page.
  ///
  /// Uses favorite songs as seeds and calls the existing recommendationsProvider
  /// to get similar songs via getSonicSimilarTracks.
  ///
  /// - Returns empty list if no seeds available.
  /// - Does NOT fallback to getSimilarSongs2.
  /// - Does NOT call AudioMuse-AI API directly.
  /// - Does NOT cache results to local database.
  ForYouRecommendationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forYouRecommendationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forYouRecommendationsHash();

  @$internal
  @override
  $FutureProviderElement<List<SongEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongEntity>> create(Ref ref) {
    return forYouRecommendations(ref);
  }
}

String _$forYouRecommendationsHash() =>
    r'47cf744176c5c235ddd195cfd242f5d1b5db4eba';
