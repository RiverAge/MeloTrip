// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    _Configuration(
      username: json['username'] as String?,
      maxRate: json['max_rate'] as String?,
      playlistMode: $enumDecodeNullable(
        _$PlaylistModeEnumMap,
        json['playlist_mode'],
      ),
      shuffle: const SqliteBoolConvert().fromJson(json['shuffle']),
      recentSearches: json['recent_searches'] as String?,
      desktopLyricsConfig: json['desktop_lyrics_config'] as String?,
      theme: $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']),
      locale: const LocaleConvert().fromJson(json['locale'] as String?),
      updateAt: (json['update_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConfigurationToJson(_Configuration instance) =>
    <String, dynamic>{
      'username': instance.username,
      'max_rate': instance.maxRate,
      'playlist_mode': _$PlaylistModeEnumMap[instance.playlistMode],
      'shuffle': const SqliteBoolConvert().toJson(instance.shuffle),
      'recent_searches': instance.recentSearches,
      'desktop_lyrics_config': instance.desktopLyricsConfig,
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
