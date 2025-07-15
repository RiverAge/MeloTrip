// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_songs2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SimilarSongs2Entity _$SimilarSongs2EntityFromJson(Map<String, dynamic> json) =>
    _SimilarSongs2Entity(
      song:
          (json['song'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SimilarSongs2EntityToJson(
  _SimilarSongs2Entity instance,
) => <String, dynamic>{'song': instance.song};
