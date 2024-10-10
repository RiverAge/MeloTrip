// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaylistEntityImpl _$$PlaylistEntityImplFromJson(Map<String, dynamic> json) =>
    _$PlaylistEntityImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      comment: json['comment'] as String?,
      songCount: (json['songCount'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      public: json['public'] as bool?,
      owner: json['owner'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      changed: json['changed'] == null
          ? null
          : DateTime.parse(json['changed'] as String),
      coverArt: json['coverArt'] as String?,
      entry: (json['entry'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlaylistEntityImplToJson(
        _$PlaylistEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comment': instance.comment,
      'songCount': instance.songCount,
      'duration': instance.duration,
      'public': instance.public,
      'owner': instance.owner,
      'created': instance.created?.toIso8601String(),
      'changed': instance.changed?.toIso8601String(),
      'coverArt': instance.coverArt,
      'entry': instance.entry,
    };

_$PlaylistsEntityImpl _$$PlaylistsEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaylistsEntityImpl(
      playlist: (json['playlist'] as List<dynamic>?)
          ?.map((e) => PlaylistEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlaylistsEntityImplToJson(
        _$PlaylistsEntityImpl instance) =>
    <String, dynamic>{
      'playlist': instance.playlist,
    };
