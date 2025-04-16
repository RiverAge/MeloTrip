import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_player.g.dart';

@riverpod
Future<Raw<Stream<Duration>>> positionStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.positionStream;
}

@riverpod
Future<Raw<Stream<Duration?>>> durationStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.durationStream;
}

@riverpod
Future<Raw<Stream<Duration>>> bufferedPositionStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.bufferedPositionStream;
}

// @riverpod
// Future<Raw<Stream<bool>>> shuffleModeEnabledStream(Ref ref) async {
//   final handler = await AppPlayerHandler.instance;
//   final player = handler.player;
//   return player.shuffleModeEnabledStream;
// }

@riverpod
Future<Raw<Stream<PlaylistMode>>> playlistModeStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.playlistModeStream;
}

@riverpod
Future<Raw<Stream<bool>>> playingStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.playingStream;
}

@riverpod
Future<Raw<Stream<PlayQueue>>> playQueueStream(Ref ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.playQueueStream;
}
