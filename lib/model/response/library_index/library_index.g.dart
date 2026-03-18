// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArtistsEntity _$ArtistsEntityFromJson(Map<String, dynamic> json) =>
    _ArtistsEntity(
      index: (json['index'] as List<dynamic>?)
          ?.map(
            (e) => ArtistIndexBucketEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ArtistsEntityToJson(_ArtistsEntity instance) =>
    <String, dynamic>{'index': instance.index};

_ArtistIndexBucketEntity _$ArtistIndexBucketEntityFromJson(
  Map<String, dynamic> json,
) => _ArtistIndexBucketEntity(
  name: json['name'] as String?,
  artist: (json['artist'] as List<dynamic>?)
      ?.map((e) => ArtistEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ArtistIndexBucketEntityToJson(
  _ArtistIndexBucketEntity instance,
) => <String, dynamic>{'name': instance.name, 'artist': instance.artist};

_IndexesEntity _$IndexesEntityFromJson(Map<String, dynamic> json) =>
    _IndexesEntity(
      lastModified: json['lastModified'] as String?,
      index: (json['index'] as List<dynamic>?)
          ?.map(
            (e) => ArtistIndexBucketEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$IndexesEntityToJson(_IndexesEntity instance) =>
    <String, dynamic>{
      'lastModified': instance.lastModified,
      'index': instance.index,
    };

_DirectoryEntity _$DirectoryEntityFromJson(Map<String, dynamic> json) =>
    _DirectoryEntity(
      id: json['id'] as String?,
      parent: json['parent'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      child: (json['child'] as List<dynamic>?)
          ?.map((e) => DirectoryChildEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DirectoryEntityToJson(_DirectoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'title': instance.title,
      'child': instance.child,
    };

_DirectoryChildEntity _$DirectoryChildEntityFromJson(
  Map<String, dynamic> json,
) => _DirectoryChildEntity(
  id: json['id'] as String?,
  parent: json['parent'] as String?,
  isDir: json['isDir'] as bool?,
  title: json['title'] as String?,
  name: json['name'] as String?,
  album: json['album'] as String?,
  genre: json['genre'] as String?,
  year: (json['year'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
  coverArt: json['coverArt'] as String?,
  artist: json['artist'] as String?,
);

Map<String, dynamic> _$DirectoryChildEntityToJson(
  _DirectoryChildEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'parent': instance.parent,
  'isDir': instance.isDir,
  'title': instance.title,
  'name': instance.name,
  'album': instance.album,
  'genre': instance.genre,
  'year': instance.year,
  'duration': instance.duration,
  'coverArt': instance.coverArt,
  'artist': instance.artist,
};
