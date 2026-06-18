// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_info2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArtistInfo2Entity _$ArtistInfo2EntityFromJson(Map<String, dynamic> json) =>
    _ArtistInfo2Entity(
      similarArtist: (json['similarArtist'] as List<dynamic>?)
          ?.map((e) => ArtistEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistInfo2EntityToJson(_ArtistInfo2Entity instance) =>
    <String, dynamic>{'similarArtist': instance.similarArtist};
