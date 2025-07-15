// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    _Configuration(
      userId: json['user_id'] as String?,
      maxRate: json['max_rate'] as String?,
      playlistMode: $enumDecodeNullable(
        _$PlaylistModeEnumMap,
        json['playlist_mode'],
      ),
      recentSearches: json['recent_searches'] as String?,
      theme: $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']),
      locale: const LocaleConvert().fromJson(json['locale'] as String?),
      updateAt: (json['update_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConfigurationToJson(_Configuration instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'max_rate': instance.maxRate,
      'playlist_mode': _$PlaylistModeEnumMap[instance.playlistMode],
      'recent_searches': instance.recentSearches,
      'theme': _$ThemeModeEnumMap[instance.theme],
      'locale': const LocaleConvert().toJson(instance.locale),
      'update_at': instance.updateAt,
    };

const _$PlaylistModeEnumMap = {
  PlaylistMode.none: 'none',
  PlaylistMode.single: 'single',
  PlaylistMode.loop: 'loop',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
