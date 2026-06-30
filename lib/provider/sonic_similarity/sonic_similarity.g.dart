// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonic_similarity.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for fetching similar songs using Sonic Similarity API.
///
/// IMPORTANT: Does NOT fallback to getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable or returns empty,
/// the result will be empty or an error.
///
/// Empty results are valid - the feature works but no similar songs were found.
/// Errors (404/501/network) are returned as Result.err without caching.

@ProviderFor(SimilarSongs)
final similarSongsProvider = SimilarSongsFamily._();

/// Provider for fetching similar songs using Sonic Similarity API.
///
/// IMPORTANT: Does NOT fallback to getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable or returns empty,
/// the result will be empty or an error.
///
/// Empty results are valid - the feature works but no similar songs were found.
/// Errors (404/501/network) are returned as Result.err without caching.
final class SimilarSongsProvider
    extends
        $AsyncNotifierProvider<
          SimilarSongs,
          Result<SonicSimilarityResult, AppFailure>
        > {
  /// Provider for fetching similar songs using Sonic Similarity API.
  ///
  /// IMPORTANT: Does NOT fallback to getSimilarSongs2.
  /// If getSonicSimilarTracks is unavailable or returns empty,
  /// the result will be empty or an error.
  ///
  /// Empty results are valid - the feature works but no similar songs were found.
  /// Errors (404/501/network) are returned as Result.err without caching.
  SimilarSongsProvider._({
    required SimilarSongsFamily super.from,
    required ({String songId, int? count}) super.argument,
  }) : super(
         retry: null,
         name: r'similarSongsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$similarSongsHash();

  @override
  String toString() {
    return r'similarSongsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SimilarSongs create() => SimilarSongs();

  @override
  bool operator ==(Object other) {
    return other is SimilarSongsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$similarSongsHash() => r'ce18a0beb672d93abe13b0155c3fb6ef6702860e';

/// Provider for fetching similar songs using Sonic Similarity API.
///
/// IMPORTANT: Does NOT fallback to getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable or returns empty,
/// the result will be empty or an error.
///
/// Empty results are valid - the feature works but no similar songs were found.
/// Errors (404/501/network) are returned as Result.err without caching.

final class SimilarSongsFamily extends $Family
    with
        $ClassFamilyOverride<
          SimilarSongs,
          AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
          Result<SonicSimilarityResult, AppFailure>,
          FutureOr<Result<SonicSimilarityResult, AppFailure>>,
          ({String songId, int? count})
        > {
  SimilarSongsFamily._()
    : super(
        retry: null,
        name: r'similarSongsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for fetching similar songs using Sonic Similarity API.
  ///
  /// IMPORTANT: Does NOT fallback to getSimilarSongs2.
  /// If getSonicSimilarTracks is unavailable or returns empty,
  /// the result will be empty or an error.
  ///
  /// Empty results are valid - the feature works but no similar songs were found.
  /// Errors (404/501/network) are returned as Result.err without caching.

  SimilarSongsProvider call({required String songId, int? count}) =>
      SimilarSongsProvider._(
        argument: (songId: songId, count: count),
        from: this,
      );

  @override
  String toString() => r'similarSongsProvider';
}

/// Provider for fetching similar songs using Sonic Similarity API.
///
/// IMPORTANT: Does NOT fallback to getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable or returns empty,
/// the result will be empty or an error.
///
/// Empty results are valid - the feature works but no similar songs were found.
/// Errors (404/501/network) are returned as Result.err without caching.

abstract class _$SimilarSongs
    extends $AsyncNotifier<Result<SonicSimilarityResult, AppFailure>> {
  late final _$args = ref.$arg as ({String songId, int? count});
  String get songId => _$args.songId;
  int? get count => _$args.count;

  FutureOr<Result<SonicSimilarityResult, AppFailure>> build({
    required String songId,
    int? count,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
              Result<SonicSimilarityResult, AppFailure>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
                Result<SonicSimilarityResult, AppFailure>
              >,
              AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(songId: _$args.songId, count: _$args.count),
    );
  }
}

/// Provider for sonic path between two songs.
///
/// Generates an acoustic transition path from start to end song.
/// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
///
/// Empty results are valid - the feature works but no path was found.
/// Errors (404/501/network) are returned as Result.err without caching.

@ProviderFor(SonicPath)
final sonicPathProvider = SonicPathFamily._();

/// Provider for sonic path between two songs.
///
/// Generates an acoustic transition path from start to end song.
/// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
///
/// Empty results are valid - the feature works but no path was found.
/// Errors (404/501/network) are returned as Result.err without caching.
final class SonicPathProvider
    extends
        $AsyncNotifierProvider<
          SonicPath,
          Result<SonicSimilarityResult, AppFailure>
        > {
  /// Provider for sonic path between two songs.
  ///
  /// Generates an acoustic transition path from start to end song.
  /// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
  ///
  /// Empty results are valid - the feature works but no path was found.
  /// Errors (404/501/network) are returned as Result.err without caching.
  SonicPathProvider._({
    required SonicPathFamily super.from,
    required ({String startSongId, String endSongId, int? count})
    super.argument,
  }) : super(
         retry: null,
         name: r'sonicPathProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonicPathHash();

  @override
  String toString() {
    return r'sonicPathProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SonicPath create() => SonicPath();

  @override
  bool operator ==(Object other) {
    return other is SonicPathProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonicPathHash() => r'fd6abbe8e8f35beae81e722f2780e76e890b230d';

/// Provider for sonic path between two songs.
///
/// Generates an acoustic transition path from start to end song.
/// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
///
/// Empty results are valid - the feature works but no path was found.
/// Errors (404/501/network) are returned as Result.err without caching.

final class SonicPathFamily extends $Family
    with
        $ClassFamilyOverride<
          SonicPath,
          AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
          Result<SonicSimilarityResult, AppFailure>,
          FutureOr<Result<SonicSimilarityResult, AppFailure>>,
          ({String startSongId, String endSongId, int? count})
        > {
  SonicPathFamily._()
    : super(
        retry: null,
        name: r'sonicPathProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for sonic path between two songs.
  ///
  /// Generates an acoustic transition path from start to end song.
  /// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
  ///
  /// Empty results are valid - the feature works but no path was found.
  /// Errors (404/501/network) are returned as Result.err without caching.

  SonicPathProvider call({
    required String startSongId,
    required String endSongId,
    int? count,
  }) => SonicPathProvider._(
    argument: (startSongId: startSongId, endSongId: endSongId, count: count),
    from: this,
  );

  @override
  String toString() => r'sonicPathProvider';
}

/// Provider for sonic path between two songs.
///
/// Generates an acoustic transition path from start to end song.
/// Uses the findSonicPath endpoint from AudioMuse-AI plugin.
///
/// Empty results are valid - the feature works but no path was found.
/// Errors (404/501/network) are returned as Result.err without caching.

abstract class _$SonicPath
    extends $AsyncNotifier<Result<SonicSimilarityResult, AppFailure>> {
  late final _$args =
      ref.$arg as ({String startSongId, String endSongId, int? count});
  String get startSongId => _$args.startSongId;
  String get endSongId => _$args.endSongId;
  int? get count => _$args.count;

  FutureOr<Result<SonicSimilarityResult, AppFailure>> build({
    required String startSongId,
    required String endSongId,
    int? count,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
              Result<SonicSimilarityResult, AppFailure>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
                Result<SonicSimilarityResult, AppFailure>
              >,
              AsyncValue<Result<SonicSimilarityResult, AppFailure>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        startSongId: _$args.startSongId,
        endSongId: _$args.endSongId,
        count: _$args.count,
      ),
    );
  }
}

/// Tracks recently returned recommendation song IDs.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.
///
/// State is persisted in user_config (recommend_refresh_state) so that it
/// survives app restarts and avoids re-recommending songs the user has
/// already seen in a prior session.

@ProviderFor(RecentRecommendationHistory)
final recentRecommendationHistoryProvider =
    RecentRecommendationHistoryProvider._();

/// Tracks recently returned recommendation song IDs.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.
///
/// State is persisted in user_config (recommend_refresh_state) so that it
/// survives app restarts and avoids re-recommending songs the user has
/// already seen in a prior session.
final class RecentRecommendationHistoryProvider
    extends $AsyncNotifierProvider<RecentRecommendationHistory, List<String>> {
  /// Tracks recently returned recommendation song IDs.
  ///
  /// Recommendations use this as a soft exclusion list. If fresh candidates are
  /// insufficient, old recommendations can still be used as fallback.
  ///
  /// State is persisted in user_config (recommend_refresh_state) so that it
  /// survives app restarts and avoids re-recommending songs the user has
  /// already seen in a prior session.
  RecentRecommendationHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentRecommendationHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentRecommendationHistoryHash();

  @$internal
  @override
  RecentRecommendationHistory create() => RecentRecommendationHistory();
}

String _$recentRecommendationHistoryHash() =>
    r'13679c021591fd2afcf78abdbc54f21c1a698102';

/// Tracks recently returned recommendation song IDs.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.
///
/// State is persisted in user_config (recommend_refresh_state) so that it
/// survives app restarts and avoids re-recommending songs the user has
/// already seen in a prior session.

abstract class _$RecentRecommendationHistory
    extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for client-side recommendations.
///
/// Generates recommendations from user-provided seed song IDs.
/// Each seed calls getSonicSimilarTracks to find similar songs.
///
/// Results are deduplicated and ranked by:
/// - Recent recommendation avoidance when enough fresh candidates exist
/// - Artist diversity (max 3 songs per artist)
/// - Album diversity (max 3 songs per album)
///
/// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
/// seedSongIds.
///
/// IMPORTANT: Does NOT call getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable, returns empty list.

@ProviderFor(Recommendations)
final recommendationsProvider = RecommendationsFamily._();

/// Provider for client-side recommendations.
///
/// Generates recommendations from user-provided seed song IDs.
/// Each seed calls getSonicSimilarTracks to find similar songs.
///
/// Results are deduplicated and ranked by:
/// - Recent recommendation avoidance when enough fresh candidates exist
/// - Artist diversity (max 3 songs per artist)
/// - Album diversity (max 3 songs per album)
///
/// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
/// seedSongIds.
///
/// IMPORTANT: Does NOT call getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable, returns empty list.
final class RecommendationsProvider
    extends $AsyncNotifierProvider<Recommendations, List<SongEntity>> {
  /// Provider for client-side recommendations.
  ///
  /// Generates recommendations from user-provided seed song IDs.
  /// Each seed calls getSonicSimilarTracks to find similar songs.
  ///
  /// Results are deduplicated and ranked by:
  /// - Recent recommendation avoidance when enough fresh candidates exist
  /// - Artist diversity (max 3 songs per artist)
  /// - Album diversity (max 3 songs per album)
  ///
  /// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
  /// seedSongIds.
  ///
  /// IMPORTANT: Does NOT call getSimilarSongs2.
  /// If getSonicSimilarTracks is unavailable, returns empty list.
  RecommendationsProvider._({
    required RecommendationsFamily super.from,
    required ({
      int limit,
      List<String>? seedSongIds,
      List<WeightedSeed>? weightedSeeds,
      List<String>? excludedSongIds,
      int refreshNonce,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'recommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recommendationsHash();

  @override
  String toString() {
    return r'recommendationsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Recommendations create() => Recommendations();

  @override
  bool operator ==(Object other) {
    return other is RecommendationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recommendationsHash() => r'04636e1aa0f817e06aa9617592f68bd8b0e3ce57';

/// Provider for client-side recommendations.
///
/// Generates recommendations from user-provided seed song IDs.
/// Each seed calls getSonicSimilarTracks to find similar songs.
///
/// Results are deduplicated and ranked by:
/// - Recent recommendation avoidance when enough fresh candidates exist
/// - Artist diversity (max 3 songs per artist)
/// - Album diversity (max 3 songs per album)
///
/// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
/// seedSongIds.
///
/// IMPORTANT: Does NOT call getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable, returns empty list.

final class RecommendationsFamily extends $Family
    with
        $ClassFamilyOverride<
          Recommendations,
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>,
          ({
            int limit,
            List<String>? seedSongIds,
            List<WeightedSeed>? weightedSeeds,
            List<String>? excludedSongIds,
            int refreshNonce,
          })
        > {
  RecommendationsFamily._()
    : super(
        retry: null,
        name: r'recommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for client-side recommendations.
  ///
  /// Generates recommendations from user-provided seed song IDs.
  /// Each seed calls getSonicSimilarTracks to find similar songs.
  ///
  /// Results are deduplicated and ranked by:
  /// - Recent recommendation avoidance when enough fresh candidates exist
  /// - Artist diversity (max 3 songs per artist)
  /// - Album diversity (max 3 songs per album)
  ///
  /// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
  /// seedSongIds.
  ///
  /// IMPORTANT: Does NOT call getSimilarSongs2.
  /// If getSonicSimilarTracks is unavailable, returns empty list.

  RecommendationsProvider call({
    int limit = 20,
    List<String>? seedSongIds,
    List<WeightedSeed>? weightedSeeds,
    List<String>? excludedSongIds,
    int refreshNonce = 0,
  }) => RecommendationsProvider._(
    argument: (
      limit: limit,
      seedSongIds: seedSongIds,
      weightedSeeds: weightedSeeds,
      excludedSongIds: excludedSongIds,
      refreshNonce: refreshNonce,
    ),
    from: this,
  );

  @override
  String toString() => r'recommendationsProvider';
}

/// Provider for client-side recommendations.
///
/// Generates recommendations from user-provided seed song IDs.
/// Each seed calls getSonicSimilarTracks to find similar songs.
///
/// Results are deduplicated and ranked by:
/// - Recent recommendation avoidance when enough fresh candidates exist
/// - Artist diversity (max 3 songs per artist)
/// - Album diversity (max 3 songs per album)
///
/// NOTE: Does NOT automatically extract seeds. Seeds must be provided via
/// seedSongIds.
///
/// IMPORTANT: Does NOT call getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable, returns empty list.

abstract class _$Recommendations extends $AsyncNotifier<List<SongEntity>> {
  late final _$args =
      ref.$arg
          as ({
            int limit,
            List<String>? seedSongIds,
            List<WeightedSeed>? weightedSeeds,
            List<String>? excludedSongIds,
            int refreshNonce,
          });
  int get limit => _$args.limit;
  List<String>? get seedSongIds => _$args.seedSongIds;
  List<WeightedSeed>? get weightedSeeds => _$args.weightedSeeds;
  List<String>? get excludedSongIds => _$args.excludedSongIds;
  int get refreshNonce => _$args.refreshNonce;

  FutureOr<List<SongEntity>> build({
    int limit = 20,
    List<String>? seedSongIds,
    List<WeightedSeed>? weightedSeeds,
    List<String>? excludedSongIds,
    int refreshNonce = 0,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SongEntity>>, List<SongEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SongEntity>>, List<SongEntity>>,
              AsyncValue<List<SongEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        limit: _$args.limit,
        seedSongIds: _$args.seedSongIds,
        weightedSeeds: _$args.weightedSeeds,
        excludedSongIds: _$args.excludedSongIds,
        refreshNonce: _$args.refreshNonce,
      ),
    );
  }
}

/// Provider for radio mode queue generation.
///
/// Radio mode continuously generates a play queue based on:
/// - A seed song (the starting point)
/// - Similar songs from getSonicSimilarTracks
/// - Auto-extends when queue nears end
///
/// IMPORTANT: Does NOT use getSimilarSongs2.

@ProviderFor(RadioQueue)
final radioQueueProvider = RadioQueueProvider._();

/// Provider for radio mode queue generation.
///
/// Radio mode continuously generates a play queue based on:
/// - A seed song (the starting point)
/// - Similar songs from getSonicSimilarTracks
/// - Auto-extends when queue nears end
///
/// IMPORTANT: Does NOT use getSimilarSongs2.
final class RadioQueueProvider
    extends $NotifierProvider<RadioQueue, List<SongEntity>> {
  /// Provider for radio mode queue generation.
  ///
  /// Radio mode continuously generates a play queue based on:
  /// - A seed song (the starting point)
  /// - Similar songs from getSonicSimilarTracks
  /// - Auto-extends when queue nears end
  ///
  /// IMPORTANT: Does NOT use getSimilarSongs2.
  RadioQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radioQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radioQueueHash();

  @$internal
  @override
  RadioQueue create() => RadioQueue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SongEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SongEntity>>(value),
    );
  }
}

String _$radioQueueHash() => r'18df5374f0107d4a456aefe23430e21ffef5cc8e';

/// Provider for radio mode queue generation.
///
/// Radio mode continuously generates a play queue based on:
/// - A seed song (the starting point)
/// - Similar songs from getSonicSimilarTracks
/// - Auto-extends when queue nears end
///
/// IMPORTANT: Does NOT use getSimilarSongs2.

abstract class _$RadioQueue extends $Notifier<List<SongEntity>> {
  List<SongEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<SongEntity>, List<SongEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SongEntity>, List<SongEntity>>,
              List<SongEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
