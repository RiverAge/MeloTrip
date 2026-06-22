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
        $NotifierProvider<
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForYouRecommendationRefreshState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForYouRecommendationRefreshState>(
        value,
      ),
    );
  }
}

String _$forYouRecommendationRefreshHash() =>
    r'e2b41ff1f98fd72a6b74845c97eb7a63f89c6efe';

abstract class _$ForYouRecommendationRefresh
    extends $Notifier<ForYouRecommendationRefreshState> {
  ForYouRecommendationRefreshState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              ForYouRecommendationRefreshState,
              ForYouRecommendationRefreshState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ForYouRecommendationRefreshState,
                ForYouRecommendationRefreshState
              >,
              ForYouRecommendationRefreshState,
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
/// - Does NOT cache results to local database.

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
  /// Uses aggregated user taste seeds and calls the existing
  /// recommendationsProvider to get similar songs via getSonicSimilarTracks.
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
    r'fa5cc9791d8740a90573a25f5f82979c3b3f4990';
