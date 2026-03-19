import 'dart:convert';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'desktop_lyrics_settings_provider.g.dart';

@riverpod
class DesktopLyricsSettings extends _$DesktopLyricsSettings {
  static const DesktopLyricsConfig _defaultConfig = DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: false,
      clickThrough: false,
    ),
    text: DesktopLyricsTextConfig(fontSize: 34, textAlign: .center),
    background: DesktopLyricsBackgroundConfig(opacity: 0.93),
    gradient: DesktopLyricsGradientConfig(),
    layout: DesktopLyricsLayoutConfig(overlayWidth: 980),
  );

  static const List<FontWeight> _fontWeights = <FontWeight>[
    .w100,
    .w200,
    .w300,
    .w400,
    .w500,
    .w600,
    .w700,
    .w800,
    .w900,
  ];

  @override
  Future<DesktopLyricsConfig> build() async {
    final configuration = await ref.watch(userConfigProvider.future);
    return _decodeStoredConfig(configuration?.desktopLyricsConfig);
  }

  Future<void> updateConfig(DesktopLyricsConfig config) async {
    state = AsyncData(config);
    await ref.read(userConfigProvider.notifier).setConfiguration(
      desktopLyricsConfig: ValueUpdater<String?>(
        jsonEncode(_encodeConfig(config)),
      ),
    );
  }

  DesktopLyricsConfig _decodeStoredConfig(String? configText) {
    if (configText == null || configText.isEmpty) {
      return _defaultConfig;
    }

    try {
      final json = jsonDecode(configText) as Map<String, dynamic>;
      return _decodeConfig(json);
    } catch (_) {
      return _defaultConfig;
    }
  }

  DesktopLyricsConfig _decodeConfig(Map<String, dynamic> json) {
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
        textAlign: _decodeTextAlign(json['textAlign'] as int?),
        fontWeight: _decodeFontWeight(json['fontWeight'] as int?),
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

  Map<String, Object> _encodeConfig(DesktopLyricsConfig config) {
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
      'textAlign': config.text.textAlign?.index ?? TextAlign.center.index,
      'fontWeight': _encodeFontWeight(config.text.fontWeight),
    };
  }

  TextAlign _decodeTextAlign(int? index) {
    final resolvedIndex = index ?? TextAlign.center.index;
    return TextAlign.values[resolvedIndex % TextAlign.values.length];
  }

  FontWeight _decodeFontWeight(int? index) {
    final resolvedIndex = index ?? 3;
    return _fontWeights[resolvedIndex % _fontWeights.length];
  }

  int _encodeFontWeight(FontWeight? fontWeight) {
    return (fontWeight?.value ?? 400) ~/ 100 - 1;
  }
}
