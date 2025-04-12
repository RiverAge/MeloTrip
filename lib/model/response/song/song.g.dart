// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SongEntity _$SongEntityFromJson(Map<String, dynamic> json) => _SongEntity(
  id: json['id'] as String?,
  parent: json['parent'] as String?,
  isDir: json['isDir'] as bool?,
  title: json['title'] as String?,
  album: json['album'] as String?,
  artist: json['artist'] as String?,
  track: (json['track'] as num?)?.toInt(),
  year: (json['year'] as num?)?.toInt(),
  coverArt: json['coverArt'] as String?,
  size: (json['size'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
  suffix: json['suffix'] as String?,
  starred:
      json['starred'] == null
          ? null
          : DateTime.parse(json['starred'] as String),
  duration: (json['duration'] as num?)?.toInt(),
  bitRate: (json['bitRate'] as num?)?.toInt(),
  path: json['path'] as String?,
  discNumber: (json['discNumber'] as num?)?.toInt(),
  created:
      json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
  albumId: json['albumId'] as String?,
  artistId: json['artistId'] as String?,
  type: json['type'] as String?,
  userRating: (json['userRating'] as num?)?.toInt(),
  isVideo: json['isVideo'] as bool?,
  bpm: (json['bpm'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  sortName: json['sortName'] as String?,
  mediaType: json['mediaType'] as String?,
  musicBrainzId: json['musicBrainzId'] as String?,
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreElement.fromJson(e as Map<String, dynamic>))
          .toList(),
  replayGain:
      json['replayGain'] == null
          ? null
          : ReplayGain.fromJson(json['replayGain'] as Map<String, dynamic>),
  channelCount: (json['channelCount'] as num?)?.toInt(),
  genre: json['genre'] as String?,
  samplingRate: (json['samplingRate'] as num?)?.toInt(),
);

Map<String, dynamic> _$SongEntityToJson(_SongEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'isDir': instance.isDir,
      'title': instance.title,
      'album': instance.album,
      'artist': instance.artist,
      'track': instance.track,
      'year': instance.year,
      'coverArt': instance.coverArt,
      'size': instance.size,
      'contentType': instance.contentType,
      'suffix': instance.suffix,
      'starred': instance.starred?.toIso8601String(),
      'duration': instance.duration,
      'bitRate': instance.bitRate,
      'path': instance.path,
      'discNumber': instance.discNumber,
      'created': instance.created?.toIso8601String(),
      'albumId': instance.albumId,
      'artistId': instance.artistId,
      'type': instance.type,
      'userRating': instance.userRating,
      'isVideo': instance.isVideo,
      'bpm': instance.bpm,
      'comment': instance.comment,
      'sortName': instance.sortName,
      'mediaType': instance.mediaType,
      'musicBrainzId': instance.musicBrainzId,
      'genres': instance.genres,
      'replayGain': instance.replayGain,
      'channelCount': instance.channelCount,
      'genre': instance.genre,
      'samplingRate': instance.samplingRate,
    };

_GenreElement _$GenreElementFromJson(Map<String, dynamic> json) =>
    _GenreElement(name: json['name'] as String?);

Map<String, dynamic> _$GenreElementToJson(_GenreElement instance) =>
    <String, dynamic>{'name': instance.name};

_ReplayGain _$ReplayGainFromJson(Map<String, dynamic> json) => _ReplayGain(
  trackPeak: (json['trackPeak'] as num?)?.toInt(),
  albumPeak: (json['albumPeak'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReplayGainToJson(_ReplayGain instance) =>
    <String, dynamic>{
      'trackPeak': instance.trackPeak,
      'albumPeak': instance.albumPeak,
    };
