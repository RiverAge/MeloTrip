import 'package:just_audio/just_audio.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/svc/app_player_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_player.g.dart';

@riverpod
Future<AppPlayer> appPlayer(AppPlayerRef ref) async {
  final handler = await AppPlayerHandler.instance;
  return handler.player;
}

class PlaylistState {
  PlaylistState(
      {required this.songs, required this.index, required this.playing});
  List<SongEntity>? songs;
  int? index;
  bool? playing;
}

@riverpod
Future<Raw<Stream<Duration>>> positionStream(PositionStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.positionStream;
}

@riverpod
Future<Raw<Stream<Duration?>>> durationStream(DurationStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.durationStream;
}

@riverpod
Future<Raw<Stream<Duration>>> bufferedPositionStream(
    BufferedPositionStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.bufferedPositionStream;
}

@riverpod
Future<Raw<Stream<PlayerState>>> playerStateStream(
    PlayerStateStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.playerStateStream;
}

@riverpod
Future<Raw<Stream<bool>>> shuffleModeEnabledStream(
    ShuffleModeEnabledStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.shuffleModeEnabledStream;
}

@riverpod
Future<Raw<Stream<LoopMode>>> loopModeStream(LoopModeStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.loopModeStream;
}

@riverpod
Future<Raw<Stream<int?>>> currentIndexStream(CurrentIndexStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.currentIndexStream;
}

@riverpod
Future<Raw<Stream<bool>>> playingStream(PlayingStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.playingStream;
}

@riverpod
Future<Raw<Stream<List<SongEntity?>?>>> sequenceStream(
    SequenceStreamRef ref) async {
  final handler = await AppPlayerHandler.instance;
  final player = handler.player;
  return player.sequenceStream;
}
