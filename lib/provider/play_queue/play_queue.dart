import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/play_queue/play_queue_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_queue.g.dart';

@riverpod
Future<SubsonicResponse?> playQueue(Ref ref) async {
  final repository = ref.read(playQueueRepositoryProvider);
  return repository.fetchPlayQueue();
}
