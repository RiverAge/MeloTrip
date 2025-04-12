import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/rec_today/rec_today.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/svc/user.dart';

part 'rec_today.g.dart';

@riverpod
Future<List<SongEntity>?> recToday(Ref ref) async {
  final u = await User.instance;
  final recToday = u.recToday;
  final now = DateTime.now();
  if (recToday == null ||
      recToday.songs == null ||
      recToday.songs?.isEmpty != false ||
      (recToday.update?.year != now.year ||
          recToday.update?.month != now.month ||
          recToday.update?.day != now.day)) {
    u.recToday =
        RecTodayEntity(update: DateTime.now(), songs: await _getRandomSongs());
  }

  return u.recToday?.songs;
}

Future<List<SongEntity>> _getRandomSongs() async {
  final res =
      await Http.get<Map<String, dynamic>>('/rest/getRandomSongs?size=20');
  final data = res?.data;
  if (data != null) {
    final ret = SubsonicResponse.fromJson(data);
    return ret.subsonicResponse?.randomSongs?.song ?? [];
  }
  return [];
}
