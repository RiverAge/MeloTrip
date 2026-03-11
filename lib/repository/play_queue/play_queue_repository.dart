import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class PlayQueueRepository {
  PlayQueueRepository(this._readApi);

  final Future<dynamic> Function() _readApi;

  Future<SubsonicResponse?> fetchPlayQueue() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getPlayQueue');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final playQueueRepositoryProvider = Provider<PlayQueueRepository>((ref) {
  return PlayQueueRepository(() => ref.read(apiProvider.future));
});
