import 'dart:convert';
import 'dart:io';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'desktop_lyrics_settings_provider.g.dart';

const DesktopLyricsConfig _defaultDesktopLyricsConfig = DesktopLyricsConfig(
  interaction: DesktopLyricsInteractionConfig(
    enabled: false,
    clickThrough: false,
  ),
  text: DesktopLyricsTextConfig(fontSize: 34),
  background: DesktopLyricsBackgroundConfig(opacity: 0.93),
  gradient: DesktopLyricsGradientConfig(),
  layout: DesktopLyricsLayoutConfig(overlayWidth: 980),
);

const List<FontWeight> _desktopLyricsFontWeights = <FontWeight>[
  FontWeight.w100,
  FontWeight.w200,
  FontWeight.w300,
  FontWeight.w400,
  FontWeight.w500,
  FontWeight.w600,
  FontWeight.w700,
  FontWeight.w800,
  FontWeight.w900,
];

@riverpod
class DesktopLyricsSettings extends _$DesktopLyricsSettings {
  @override
  Future<DesktopLyricsConfig> build() async {
    final File file = await _getConfigFile();
    if (!await file.exists()) {
      return _defaultDesktopLyricsConfig;
    }
    try {
      final String text = await file.readAsString();
      final Map<String, dynamic> json =
          jsonDecode(text) as Map<String, dynamic>;
      return _decodeDesktopLyricsConfig(json);
    } catch (_) {
      return _defaultDesktopLyricsConfig;
    }
  }

  Future<File> _getConfigFile() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory meloTripDir = Directory(p.join(dir.path, 'MeloTrip'));
    if (!await meloTripDir.exists()) {
      await meloTripDir.create(recursive: true);
    }
    return File(p.join(meloTripDir.path, 'desktop_lyrics_config.json'));
  }

  Future<void> updateConfig(DesktopLyricsConfig config) async {
    state = AsyncData(config);
    try {
      final File file = await _getConfigFile();
      await file.writeAsString(jsonEncode(_encodeDesktopLyricsConfig(config)));
    } catch (_) {}
  }
}

DesktopLyricsConfig _decodeDesktopLyricsConfig(Map<String, dynamic> json) {
  final int backgroundBaseColor =
      json['backgroundBaseColor'] as int? ?? 0xFF000000;
  final double backgroundOpacity =
      (json['backgroundOpacity'] as num?)?.toDouble() ?? 0.5;

  return DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: json['interactionEnabled'] as bool? ?? false,
      clickThrough: json['clickThrough'] as bool? ?? false,
    ),
    text: DesktopLyricsTextConfig(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 34.0,
      textAlign:
          TextAlign.values[(json['textAlign'] as int? ??
                  TextAlign.start.index) %
              TextAlign.values.length],
      fontWeight:
          _desktopLyricsFontWeights[(json['fontWeight'] as int? ?? 3) %
              _desktopLyricsFontWeights.length],
      textColor: Color(json['textColor'] as int? ?? 0xFFF2F2F8),
      shadowColor: Color(json['shadowColor'] as int? ?? 0xFF121214),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 0.0,
      strokeColor: Color(json['strokeColor'] as int? ?? 0x00000000),
    ),
    background: DesktopLyricsBackgroundConfig(
      backgroundColor: Color(
        backgroundBaseColor,
      ).withValues(alpha: backgroundOpacity),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 0.93,
    ),
    gradient: DesktopLyricsGradientConfig(
      textGradientEnabled: json['gradientEnabled'] as bool? ?? false,
      textGradientStartColor: Color(
        json['gradientStartColor'] as int? ?? 0xFFFFD36E,
      ),
      textGradientEndColor: Color(
        json['gradientEndColor'] as int? ?? 0xFFFF4D8D,
      ),
    ),
    layout: DesktopLyricsLayoutConfig(
      overlayWidth: (json['overlayWidth'] as num?)?.toDouble() ?? 980.0,
    ),
  );
}

Map<String, Object> _encodeDesktopLyricsConfig(DesktopLyricsConfig config) {
  final Color backgroundColor =
      config.background.backgroundColor ?? const Color(0x7A220A35);
  return <String, Object>{
    'interactionEnabled': config.interaction.enabled,
    'clickThrough': config.interaction.clickThrough,
    'fontSize': config.text.fontSize,
    'opacity': config.background.opacity,
    'strokeWidth': config.text.strokeWidth ?? 0.0,
    'textColor': config.text.textColor?.toARGB32() ?? 0xFFF2F2F8,
    'shadowColor': config.text.shadowColor?.toARGB32() ?? 0xFF121214,
    'strokeColor': config.text.strokeColor?.toARGB32() ?? 0x00000000,
    'backgroundBaseColor':
        0xFF000000 | (backgroundColor.toARGB32() & 0x00FFFFFF),
    'backgroundOpacity': ((backgroundColor.toARGB32() >> 24) & 0xFF) / 255.0,
    'gradientEnabled': config.gradient.textGradientEnabled,
    'gradientStartColor':
        config.gradient.textGradientStartColor?.toARGB32() ?? 0xFFFFD36E,
    'gradientEndColor':
        config.gradient.textGradientEndColor?.toARGB32() ?? 0xFFFF4D8D,
    'overlayWidth': config.layout.overlayWidth ?? 980.0,
    'textAlign': config.text.textAlign?.index ?? TextAlign.start.index,
    'fontWeight': (config.text.fontWeight?.value ?? 400) ~/ 100 - 1,
  };
}
