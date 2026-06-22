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
          Result<List<SongEntity>, AppFailure>
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

String _$similarSongsHash() => r'2da413b8d415872e9616f357f3e3ce5242b862f3';

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
          AsyncValue<Result<List<SongEntity>, AppFailure>>,
          Result<List<SongEntity>, AppFailure>,
          FutureOr<Result<List<SongEntity>, AppFailure>>,
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
    extends $AsyncNotifier<Result<List<SongEntity>, AppFailure>> {
  late final _$args = ref.$arg as ({String songId, int? count});
  String get songId => _$args.songId;
  int? get count => _$args.count;

  FutureOr<Result<List<SongEntity>, AppFailure>> build({
    required String songId,
    int? count,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<List<SongEntity>, AppFailure>>,
              Result<List<SongEntity>, AppFailure>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<List<SongEntity>, AppFailure>>,
                Result<List<SongEntity>, AppFailure>
              >,
              AsyncValue<Result<List<SongEntity>, AppFailure>>,
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
          Result<List<SongEntity>, AppFailure>
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

String _$sonicPathHash() => r'ca938d303fd9569c5286eead856a578186521e64';

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
          AsyncValue<Result<List<SongEntity>, AppFailure>>,
          Result<List<SongEntity>, AppFailure>,
          FutureOr<Result<List<SongEntity>, AppFailure>>,
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
    extends $AsyncNotifier<Result<List<SongEntity>, AppFailure>> {
  late final _$args =
      ref.$arg as ({String startSongId, String endSongId, int? count});
  String get startSongId => _$args.startSongId;
  String get endSongId => _$args.endSongId;
  int? get count => _$args.count;

  FutureOr<Result<List<SongEntity>, AppFailure>> build({
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
              AsyncValue<Result<List<SongEntity>, AppFailure>>,
              Result<List<SongEntity>, AppFailure>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<List<SongEntity>, AppFailure>>,
                Result<List<SongEntity>, AppFailure>
              >,
              AsyncValue<Result<List<SongEntity>, AppFailure>>,
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

/// Tracks recently returned recommendation song IDs for the current app session.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.

@ProviderFor(RecentRecommendationHistory)
final recentRecommendationHistoryProvider =
    RecentRecommendationHistoryProvider._();

/// Tracks recently returned recommendation song IDs for the current app session.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.
final class RecentRecommendationHistoryProvider
    extends $NotifierProvider<RecentRecommendationHistory, List<String>> {
  /// Tracks recently returned recommendation song IDs for the current app session.
  ///
  /// Recommendations use this as a soft exclusion list. If fresh candidates are
  /// insufficient, old recommendations can still be used as fallback.
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentRecommendationHistoryHash() =>
    r'64a12df1e8db5591637e8e2629452eea711e4b28';

/// Tracks recently returned recommendation song IDs for the current app session.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.

abstract class _$RecentRecommendationHistory extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
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
    required ({int limit, List<String>? seedSongIds}) super.argument,
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

String _$recommendationsHash() => r'20915105262d077af2da3db3693963beaca3ab2c';

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
          ({int limit, List<String>? seedSongIds})
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

  RecommendationsProvider call({int limit = 20, List<String>? seedSongIds}) =>
      RecommendationsProvider._(
        argument: (limit: limit, seedSongIds: seedSongIds),
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
  late final _$args = ref.$arg as ({int limit, List<String>? seedSongIds});
  int get limit => _$args.limit;
  List<String>? get seedSongIds => _$args.seedSongIds;

  FutureOr<List<SongEntity>> build({int limit = 20, List<String>? seedSongIds});
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
      () => build(limit: _$args.limit, seedSongIds: _$args.seedSongIds),
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

String _$radioQueueHash() => r'15f91e37fc58b5c86d4ad8aa2f60a73c190b4b08';

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
