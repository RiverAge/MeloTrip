import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/favorite_weighted_seeds.dart';
import 'package:melo_trip/provider/recommendation/playlist_weighted_seeds.dart';
import 'package:melo_trip/provider/recommendation/user_taste_seeds.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendation_sections.g.dart';

@riverpod
Future<List<SongEntity>> dailyRecommendations(
  Ref ref, {
  int limit = 30,
  int refreshNonce = 0,
}) async {
  final seeds = await ref.watch(userTasteSeedsProvider.future);
  final todayKey = _todayKey(DateTime.now());
  return _recommendFromSeeds(
    ref,
    seeds: seeds,
    limit: limit,
    refreshNonce: todayKey * 1000 + refreshNonce,
  );
}

@riverpod
Future<List<SongEntity>> favoriteBasedRecommendations(
  Ref ref, {
  int limit = 30,
  int refreshNonce = 0,
}) async {
  final seeds = await ref.watch(favoriteWeightedSeedsProvider.future);
  return _recommendFromSeeds(
    ref,
    seeds: seeds,
    limit: limit,
    refreshNonce: refreshNonce,
  );
}

@riverpod
Future<List<SongEntity>> playlistBasedRecommendations(
  Ref ref, {
  int limit = 30,
  int refreshNonce = 0,
}) async {
  final seeds = await ref.watch(playlistWeightedSeedsProvider().future);
  return _recommendFromSeeds(
    ref,
    seeds: seeds,
    limit: limit,
    refreshNonce: refreshNonce,
  );
}

Future<List<SongEntity>> _recommendFromSeeds(
  Ref ref, {
  required List<WeightedSeed> seeds,
  required int limit,
  int refreshNonce = 0,
}) async {
  if (seeds.isEmpty) {
    return const <SongEntity>[];
  }

  return ref.watch(
    recommendationsProvider(
      limit: limit,
      seedSongIds: seeds.map((seed) => seed.songId).toList(),
      refreshNonce: refreshNonce,
    ).future,
  );
}

int _todayKey(DateTime now) {
  return now.year * 10000 + now.month * 100 + now.day;
}
