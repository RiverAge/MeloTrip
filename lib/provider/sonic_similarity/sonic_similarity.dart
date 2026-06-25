import 'dart:math';

import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/sonic_similarity_result.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sonic_similarity.g.dart';

/// Pure function for filtering radio queue candidates.
///
/// Filters out:
/// - Songs with null id
/// - Songs matching the seed song id
/// - Songs already in seenIds
/// - Duplicate songIds within this batch (keeps first occurrence)
///
/// Preserves input order from getSonicSimilarTracks.
/// [limit] controls the maximum number of songs to return.
List<SongEntity> filterRadioQueueCandidates({
  required Iterable<SongEntity> songs,
  required Set<String> seenIds,
  String? seedId,
  int? limit,
}) {
  final result = <SongEntity>[];
  final addedIds = <String>{};

  for (final song in songs) {
    // Stop if limit reached
    if (limit != null && result.length >= limit) break;

    // Skip null ids
    if (song.id == null) continue;

    // Skip seed song
    if (song.id == seedId) continue;

    // Skip already seen
    if (seenIds.contains(song.id)) continue;

    // Skip duplicates within this batch
    if (addedIds.contains(song.id)) continue;

    result.add(song);
    addedIds.add(song.id!);
  }

  return result;
}

/// Provider for fetching similar songs using Sonic Similarity API.
///
/// IMPORTANT: Does NOT fallback to getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable or returns empty,
/// the result will be empty or an error.
///
/// Empty results are valid - the feature works but no similar songs were found.
/// Errors (404/501/network) are returned as Result.err without caching.
@riverpod
class SimilarSongs extends _$SimilarSongs {
  @override
  Future<Result<SonicSimilarityResult, AppFailure>> build({
    required String songId,
    int? count,
  }) async {
    final repository = ref.read(sonicSimilarityRepositoryProvider);
    return repository.tryFetchSonicSimilarTracks(
      id: songId,
      count: count ?? 20,
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
@riverpod
class SonicPath extends _$SonicPath {
  @override
  Future<Result<SonicSimilarityResult, AppFailure>> build({
    required String startSongId,
    required String endSongId,
    int? count,
  }) async {
    final repository = ref.read(sonicSimilarityRepositoryProvider);
    return repository.tryFindSonicPath(
      startSongId: startSongId,
      endSongId: endSongId,
      count: count ?? 10,
    );
  }
}

/// Tracks recently returned recommendation song IDs for the current app session.
///
/// Recommendations use this as a soft exclusion list. If fresh candidates are
/// insufficient, old recommendations can still be used as fallback.
@Riverpod(keepAlive: true)
class RecentRecommendationHistory extends _$RecentRecommendationHistory {
  @override
  List<String> build() => const <String>[];

  void record(Iterable<SongEntity> songs, {int maxItems = 80}) {
    final next = <String>[];
    final seen = <String>{};

    for (final song in songs) {
      final id = song.id;
      if (id == null || id.isEmpty || !seen.add(id)) continue;
      next.add(id);
    }

    for (final id in state) {
      if (seen.add(id)) {
        next.add(id);
      }
    }

    state = next.take(maxItems).toList();
  }

  void clear() {
    state = const <String>[];
  }
}

const Map<SeedSource, int> _defaultSeedSourceCaps = <SeedSource, int>{
  SeedSource.favorite: 4,
  SeedSource.favoriteAlbum: 2,
  SeedSource.favoriteArtist: 2,
  SeedSource.playlist: 3,
  SeedSource.recent: 2,
  SeedSource.rating: 2,
  SeedSource.current: 1,
  SeedSource.queue: 2,
  SeedSource.playHistory: 2,
};

/// Selects recommendation seeds using weight first, then source diversity.
///
/// The first pass enforces per-source caps so one signal does not dominate
/// mixed seed sets. If that leaves unused slots, the second pass fills them
/// from the strongest remaining seeds.
List<WeightedSeed> selectWeightedRecommendationSeeds({
  required Iterable<WeightedSeed> seeds,
  int maxSeeds = 8,
  int refreshNonce = 0,
}) {
  if (maxSeeds <= 0) {
    return const <WeightedSeed>[];
  }

  final bySongId = <String, WeightedSeed>{};
  for (final seed in seeds) {
    if (seed.songId.isEmpty || seed.weight <= 0) {
      continue;
    }
    final existing = bySongId[seed.songId];
    if (existing == null || seed.weight > existing.weight) {
      bySongId[seed.songId] = seed;
    }
  }

  if (bySongId.isEmpty) {
    return const <WeightedSeed>[];
  }

  final random = refreshNonce == 0 ? Random() : Random(refreshNonce);
  final scored =
      bySongId.values
          .map((seed) => _ScoredSeed(seed, _seedSelectionScore(seed, random)))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

  final selected = <WeightedSeed>[];
  final selectedIds = <String>{};
  final sourceCounts = <SeedSource, int>{};

  for (final item in scored) {
    if (selected.length >= maxSeeds) break;
    final cap = _defaultSeedSourceCaps[item.seed.source] ?? 2;
    final currentCount = sourceCounts[item.seed.source] ?? 0;
    if (currentCount >= cap) {
      continue;
    }
    selected.add(item.seed);
    selectedIds.add(item.seed.songId);
    sourceCounts[item.seed.source] = currentCount + 1;
  }

  if (selected.length < maxSeeds) {
    for (final item in scored) {
      if (selected.length >= maxSeeds) break;
      if (selectedIds.contains(item.seed.songId)) {
        continue;
      }
      selected.add(item.seed);
      selectedIds.add(item.seed.songId);
    }
  }

  return selected;
}

double _seedSelectionScore(WeightedSeed seed, Random random) {
  final jitter = 0.92 + random.nextDouble() * 0.16;
  return seed.weight * jitter;
}

class _ScoredSeed {
  const _ScoredSeed(this.seed, this.score);

  final WeightedSeed seed;
  final double score;
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
@riverpod
class Recommendations extends _$Recommendations {
  @override
  Future<List<SongEntity>> build({
    int limit = 20,
    List<String>? seedSongIds,
    List<WeightedSeed>? weightedSeeds,
    List<String>? excludedSongIds,
    int refreshNonce = 0,
  }) async {
    if (limit <= 0) {
      return const <SongEntity>[];
    }

    final recentIds = ref.read(recentRecommendationHistoryProvider).toSet();
    final excludedIds = excludedSongIds == null
        ? const <String>{}
        : excludedSongIds.where((id) => id.isNotEmpty).toSet();
    final repository = ref.read(sonicSimilarityRepositoryProvider);
    final seedCandidates = weightedSeeds ?? _weightedSeedsFromIds(seedSongIds);
    final seeds = selectWeightedRecommendationSeeds(
      seeds: seedCandidates,
      maxSeeds: 8,
      refreshNonce: refreshNonce,
    );

    if (seeds.isEmpty) {
      return const <SongEntity>[];
    }

    final random = refreshNonce == 0 ? Random() : Random(refreshNonce);
    final seedIds = seeds.map((seed) => seed.songId).toSet();
    final candidateCount = seeds.length <= 2 ? 50 : 24;
    final candidatesById = <String, _RecommendationCandidate>{};

    for (final seed in seeds) {
      final result = await repository.tryFetchSonicSimilarTracksWithScores(
        id: seed.songId,
        count: candidateCount,
      );

      result.when(
        ok: (matches) {
          for (var rank = 0; rank < matches.length; rank++) {
            final (song, similarity) = matches[rank];
            final id = song.id;
            if (id == null || id.isEmpty) continue;
            if (seedIds.contains(id)) continue;
            if (excludedIds.contains(id)) continue;

            final score = _candidateScore(
              seed: seed,
              rank: rank,
              similarity: similarity,
              isRecent: recentIds.contains(id),
              random: random,
            );
            _mergeRecommendationCandidate(
              candidatesById,
              song: song,
              score: score,
              isRecent: recentIds.contains(id),
            );
          }
        },
        err: (_) {
          // Skip failed requests - don't fallback to getSimilarSongs2
        },
      );
    }

    final recommendations = _rankRecommendationCandidates(
      candidatesById.values,
      limit: limit,
    );

    if (recommendations.isNotEmpty) {
      ref
          .read(recentRecommendationHistoryProvider.notifier)
          .record(recommendations);
    }

    return recommendations;
  }
}

List<WeightedSeed> _weightedSeedsFromIds(List<String>? seedSongIds) {
  if (seedSongIds == null || seedSongIds.isEmpty) {
    return const <WeightedSeed>[];
  }
  return seedSongIds
      .where((id) => id.isNotEmpty)
      .map(
        (id) =>
            WeightedSeed(songId: id, source: SeedSource.current, weight: 1.0),
      )
      .toList();
}

double _candidateScore({
  required WeightedSeed seed,
  required int rank,
  required double? similarity,
  required bool isRecent,
  required Random random,
}) {
  final similarityScore = (similarity == null || similarity <= 0)
      ? 1.0
      : similarity.clamp(0.0, 1.0).toDouble();
  final rankDecay = 1.0 / (1.0 + rank * 0.08);
  final recentPenalty = isRecent ? 0.35 : 1.0;
  final jitter = 0.98 + random.nextDouble() * 0.04;
  return seed.weight * similarityScore * rankDecay * recentPenalty * jitter;
}

void _mergeRecommendationCandidate(
  Map<String, _RecommendationCandidate> candidatesById, {
  required SongEntity song,
  required double score,
  required bool isRecent,
}) {
  final id = song.id;
  if (id == null || id.isEmpty) {
    return;
  }

  final existing = candidatesById[id];
  if (existing == null) {
    candidatesById[id] = _RecommendationCandidate(
      song: song,
      score: score,
      isRecent: isRecent,
    );
    return;
  }

  candidatesById[id] = existing.merge(song: song, score: score);
}

List<SongEntity> _rankRecommendationCandidates(
  Iterable<_RecommendationCandidate> candidates, {
  required int limit,
}) {
  final sorted = candidates.toList()
    ..sort((a, b) {
      if (a.isRecent != b.isRecent) {
        return a.isRecent ? 1 : -1;
      }
      return b.score.compareTo(a.score);
    });

  final strict = _selectByDiversityCaps(
    sorted,
    limit: limit,
    artistCap: 2,
    albumCap: 2,
  );
  if (strict.length >= limit) {
    return strict;
  }

  final relaxed = _selectByDiversityCaps(
    sorted,
    limit: limit,
    artistCap: 3,
    albumCap: 3,
  );
  return relaxed;
}

List<SongEntity> _selectByDiversityCaps(
  Iterable<_RecommendationCandidate> candidates, {
  required int limit,
  required int artistCap,
  required int albumCap,
}) {
  final result = <SongEntity>[];
  final seenIds = <String>{};
  final artistCount = <String, int>{};
  final albumCount = <String, int>{};

  for (final candidate in candidates) {
    if (result.length >= limit) break;
    _tryAddRecommendation(
      song: candidate.song,
      recommendations: result,
      seenIds: seenIds,
      artistCount: artistCount,
      albumCount: albumCount,
      artistCap: artistCap,
      albumCap: albumCap,
    );
  }

  return result;
}

class _RecommendationCandidate {
  const _RecommendationCandidate({
    required this.song,
    required this.score,
    required this.isRecent,
  });

  final SongEntity song;
  final double score;
  final bool isRecent;

  _RecommendationCandidate merge({
    required SongEntity song,
    required double score,
  }) {
    return _RecommendationCandidate(
      song: score > this.score ? song : this.song,
      score: this.score + score * 0.35,
      isRecent: isRecent,
    );
  }
}

bool _tryAddRecommendation({
  required SongEntity song,
  required List<SongEntity> recommendations,
  required Set<String> seenIds,
  required Map<String, int> artistCount,
  required Map<String, int> albumCount,
  required int artistCap,
  required int albumCap,
}) {
  final id = song.id;
  if (id == null || id.isEmpty || seenIds.contains(id)) {
    return false;
  }

  final artistId = song.artistId ?? song.artist;
  final albumId = song.albumId ?? song.album;

  final artistPenalty = artistCount[artistId] ?? 0;
  final albumPenalty = albumCount[albumId] ?? 0;

  if (artistPenalty >= artistCap || albumPenalty >= albumCap) {
    return false;
  }

  recommendations.add(song);
  seenIds.add(id);
  if (artistId != null) {
    artistCount[artistId] = (artistCount[artistId] ?? 0) + 1;
  }
  if (albumId != null) {
    albumCount[albumId] = (albumCount[albumId] ?? 0) + 1;
  }
  return true;
}

/// Provider for radio mode queue generation.
///
/// Radio mode continuously generates a play queue based on:
/// - A seed song (the starting point)
/// - Similar songs from getSonicSimilarTracks
/// - Auto-extends when queue nears end
///
/// IMPORTANT: Does NOT use getSimilarSongs2.
@Riverpod(keepAlive: true)
class RadioQueue extends _$RadioQueue {
  final List<SongEntity> _queue = [];
  final Set<String> _seenIds = {};
  SongEntity? _seedSong;
  bool _seedSongUnanalyzed = false;

  @override
  List<SongEntity> build() {
    ref.onDispose(() {
      _queue.clear();
      _seenIds.clear();
      _seedSong = null;
      _seedSongUnanalyzed = false;
    });
    return _queue;
  }

  /// Whether the seed song has not been analyzed by AudioMuse-AI.
  bool get isSeedSongUnanalyzed => _seedSongUnanalyzed;

  /// Start radio from a seed song.
  ///
  /// IMPORTANT: Clears internal state and publishes empty state immediately
  /// to avoid exposing stale queue on failure or null seed id.
  Future<void> startRadio(SongEntity seedSong) async {
    _queue.clear();
    _seenIds.clear();
    _seedSong = seedSong;
    _seedSongUnanalyzed = false;
    state = const []; // Publish empty state immediately

    if (seedSong.id != null) {
      _seenIds.add(seedSong.id!);
    }
    await _extendQueue();
  }

  /// Extend the radio queue with more songs.
  Future<void> extendQueue({int count = 10}) async {
    await _extendQueue(targetCount: count);
  }

  Future<void> _extendQueue({int targetCount = 10}) async {
    if (_queue.isEmpty && _seedSong == null) return;

    // Use last song in queue as reference, or seed song
    final lastSong = _queue.isNotEmpty ? _queue.last : _seedSong;
    if (lastSong?.id == null) return;

    final result = await ref.read(
      similarSongsProvider(
        songId: lastSong!.id!,
        count: targetCount * 2,
      ).future,
    );

    result.when(
      ok: (similarityResult) {
        // Check if seed song is unanalyzed
        if (similarityResult.isUnanalyzed && lastSong == _seedSong) {
          _seedSongUnanalyzed = true;
          return;
        }

        // Filter candidates preserving Sonic API order
        final candidates = filterRadioQueueCandidates(
          songs: similarityResult.songs,
          seenIds: _seenIds,
          seedId: _seedSong?.id,
          limit: targetCount,
        );

        // Add filtered candidates to queue
        for (final song in candidates) {
          _queue.add(song);
          _seenIds.add(song.id!);
        }

        state = List.from(_queue);
      },
      err: (_) {
        // Don't fallback to getSimilarSongs2
      },
    );
  }

  /// Clear the radio queue.
  void clearRadio() {
    _queue.clear();
    _seenIds.clear();
    _seedSong = null;
    _seedSongUnanalyzed = false;
    state = [];
  }

  /// Get the current seed song.
  SongEntity? get seedSong => _seedSong;

  /// Check if radio is active.
  bool get isActive => _queue.isNotEmpty || _seedSong != null;
}
