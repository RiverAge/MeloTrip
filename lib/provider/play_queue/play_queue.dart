import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_queue.g.dart';

@riverpod
Future<SubsonicResponse?> playQueue(Ref ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getPlayQueue');
  final data = res.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
