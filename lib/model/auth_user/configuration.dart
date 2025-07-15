import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart';

part 'configuration.freezed.dart';
part 'configuration.g.dart';

@freezed
abstract class Configuration with _$Configuration {
  const factory Configuration({
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'max_rate') String? maxRate,
    @JsonKey(name: 'playlist_mode') PlaylistMode? playlistMode,
    @JsonKey(name: 'recent_searches') String? recentSearches,
    ThemeMode? theme,
    @LocaleConvert() Locale? locale,
    @JsonKey(name: 'update_at') int? updateAt,
  }) = _Configuration;

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);
}

class LocaleConvert implements JsonConverter<Locale?, String?> {
  const LocaleConvert();

  @override
  Locale? fromJson(String? json) {
    if (json == null) return null;
    final parts = json.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return null;
  }

  @override
  String? toJson(Locale? locale) {
    if (locale != null) {
      return '${locale.countryCode}_${locale.languageCode}';
    }
    return null;
  }
}
