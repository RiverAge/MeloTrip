// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'for_you_recommendations.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForYouRecommendationRefresh)
final forYouRecommendationRefreshProvider =
    ForYouRecommendationRefreshProvider._();

final class ForYouRecommendationRefreshProvider
    extends
        $AsyncNotifierProvider<
          ForYouRecommendationRefresh,
          ForYouRecommendationRefreshState
        > {
  ForYouRecommendationRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forYouRecommendationRefreshProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forYouRecommendationRefreshHash();

  @$internal
  @override
  ForYouRecommendationRefresh create() => ForYouRecommendationRefresh();
}

String _$forYouRecommendationRefreshHash() =>
    r'bb1ef30b05173b587ed571ded85501018fa488d3';

abstract class _$ForYouRecommendationRefresh
    extends $AsyncNotifier<ForYouRecommendationRefreshState> {
  FutureOr<ForYouRecommendationRefreshState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ForYouRecommendationRefreshState>,
              ForYouRecommendationRefreshState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ForYouRecommendationRefreshState>,
                ForYouRecommendationRefreshState
              >,
              AsyncValue<ForYouRecommendationRefreshState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for "For You" recommendations on the home page.
///
/// Uses aggregated user taste seeds and calls the existing
/// recommendationsProvider to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Refresh state (excludedSongIds) is persisted via user_config so a restart
///   resumes from the last page instead of resetting to the first batch.

@ProviderFor(forYouRecommendations)
final forYouRecommendationsProvider = ForYouRecommendationsProvider._();

/// Provider for "For You" recommendations on the home page.
///
/// Uses aggregated user taste seeds and calls the existing
/// recommendationsProvider to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Refresh state (excludedSongIds) is persisted via user_config so a restart
///   resumes from the last page instead of resetting to the first batch.

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
  /// Uses aggregated user taste seeds and calls the existing
  /// recommendationsProvider to get similar songs via getSonicSimilarTracks.
  ///
  /// - Returns empty list if no seeds available.
  /// - Does NOT fallback to getSimilarSongs2.
  /// - Does NOT call AudioMuse-AI API directly.
  /// - Refresh state (excludedSongIds) is persisted via user_config so a restart
  ///   resumes from the last page instead of resetting to the first batch.
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
    r'0acdc7c26a5a4bddbcd9e2d837e2a60ffcf2aba9';
