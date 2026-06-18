// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonic_similarity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SonicMatch _$SonicMatchFromJson(Map<String, dynamic> json) => _SonicMatch(
  entry: json['entry'] == null
      ? null
      : SongEntity.fromJson(json['entry'] as Map<String, dynamic>),
  similarity: (json['similarity'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SonicMatchToJson(_SonicMatch instance) =>
    <String, dynamic>{
      'entry': instance.entry,
      'similarity': instance.similarity,
    };

_SonicMatchesEntity _$SonicMatchesEntityFromJson(Map<String, dynamic> json) =>
    _SonicMatchesEntity(
      sonicMatch:
          (json['sonicMatch'] as List<dynamic>?)
              ?.map((e) => SonicMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SonicMatchesEntityToJson(_SonicMatchesEntity instance) =>
    <String, dynamic>{'sonicMatch': instance.sonicMatch};
