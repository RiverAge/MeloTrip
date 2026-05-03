import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/response/song/song.dart';

const mediaExtraSong = 'song';
const mediaExtraArtUri = 'artUri';

Map<String, dynamic> buildMediaExtras({
  required SongEntity song,
  Uri? artUri,
}) {
  return <String, dynamic>{
    mediaExtraSong: song,
    mediaExtraArtUri: artUri?.toString(),
  };
}

SongEntity readMediaSong(Media media) {
  final value = media.extras?[mediaExtraSong];
  if (value is SongEntity) {
    return value;
  }
  return SongEntity();
}

Uri? readMediaArtUri(Media media) {
  final raw = media.extras?[mediaExtraArtUri];
  if (raw is! String || raw.isEmpty) {
    return null;
  }
  return Uri.tryParse(raw);
}
