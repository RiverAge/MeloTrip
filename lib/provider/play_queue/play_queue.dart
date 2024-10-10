import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_queue.g.dart';

@riverpod
Future<SubsonicResponse?> playQueue(PlayQueueRef ref) async {
  final res = await Http.get<Map<String, dynamic>>('/rest/getPlayQueue');
  final data = res?.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
