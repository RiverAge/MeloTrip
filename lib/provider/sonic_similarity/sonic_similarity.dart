import 'dart:math';

import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
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
  Future<Result<List<SongEntity>, AppFailure>> build({
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
  Future<Result<List<SongEntity>, AppFailure>> build({
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

/// Provider for client-side recommendations.
///
/// Generates recommendations from user-provided seed song IDs.
/// Each seed calls getSonicSimilarTracks to find similar songs.
///
/// Results are deduplicated and ranked by:
/// - Artist diversity (max 3 songs per artist)
/// - Album diversity (max 3 songs per album)
///
/// NOTE: Does NOT automatically extract seeds from play history,
/// starred songs, or ratings. Seeds must be provided via seedSongIds.
///
/// IMPORTANT: Does NOT call getSimilarSongs2.
/// If getSonicSimilarTracks is unavailable, returns empty list.
@riverpod
class Recommendations extends _$Recommendations {
  @override
  Future<List<SongEntity>> build({
    int limit = 20,
    List<String>? seedSongIds,
  }) async {
    final List<SongEntity> recommendations = [];
    final Set<String> seenIds = {};
    final Map<String, int> artistCount = {};
    final Map<String, int> albumCount = {};

    // Use provided seeds or empty list
    final seeds = seedSongIds ?? const [];

    if (seeds.isEmpty) {
      // No seeds available - return empty
      return [];
    }

    // Shuffle seeds for variety
    final random = Random();
    final shuffledSeeds = List<String>.from(seeds)..shuffle(random);

    // Limit concurrent API calls (max 5 seeds)
    final maxSeeds = min(shuffledSeeds.length, 5);

    for (int i = 0; i < maxSeeds && recommendations.length < limit; i++) {
      final seedId = shuffledSeeds[i];

      final result = await ref.read(
        similarSongsProvider(songId: seedId, count: 10).future,
      );

      result.when(
        ok: (songs) {
          for (final song in songs) {
            if (recommendations.length >= limit) break;
            if (song.id == null || seenIds.contains(song.id)) continue;
            // Skip if already in seed set
            if (seeds.contains(song.id)) continue;

            // Apply artist/album diversity penalty
            final artistId = song.artistId ?? song.artist;
            final albumId = song.albumId ?? song.album;

            final artistPenalty = artistCount[artistId] ?? 0;
            final albumPenalty = albumCount[albumId] ?? 0;

            // Skip if too many from same artist or album
            if (artistPenalty >= 3 || albumPenalty >= 3) continue;

            recommendations.add(song);
            seenIds.add(song.id!);
            if (artistId != null) {
              artistCount[artistId] = (artistCount[artistId] ?? 0) + 1;
            }
            if (albumId != null) {
              albumCount[albumId] = (albumCount[albumId] ?? 0) + 1;
            }
          }
        },
        err: (_) {
          // Skip failed requests - don't fallback to getSimilarSongs2
        },
      );
    }

    return recommendations;
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
@Riverpod(keepAlive: true)
class RadioQueue extends _$RadioQueue {
  final List<SongEntity> _queue = [];
  final Set<String> _seenIds = {};
  SongEntity? _seedSong;

  @override
  List<SongEntity> build() {
    ref.onDispose(() {
      _queue.clear();
      _seenIds.clear();
      _seedSong = null;
    });
    return _queue;
  }

  /// Start radio from a seed song.
  ///
  /// IMPORTANT: Clears internal state and publishes empty state immediately
  /// to avoid exposing stale queue on failure or null seed id.
  Future<void> startRadio(SongEntity seedSong) async {
    _queue.clear();
    _seenIds.clear();
    _seedSong = seedSong;
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
      ok: (songs) {
        // Filter candidates preserving Sonic API order
        final candidates = filterRadioQueueCandidates(
          songs: songs,
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
    state = [];
  }

  /// Get the current seed song.
  SongEntity? get seedSong => _seedSong;

  /// Check if radio is active.
  bool get isActive => _queue.isNotEmpty || _seedSong != null;
}
