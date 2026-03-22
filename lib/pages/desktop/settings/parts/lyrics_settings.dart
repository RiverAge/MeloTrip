import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/provider/desktop/desktop_lyrics_client.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';

part 'lyrics_settings_sections.dart';

class DesktopLyricsSettingsTab extends ConsumerStatefulWidget {
  const DesktopLyricsSettingsTab({this.onApplyConfig, super.key});

  final Future<void> Function(DesktopLyricsConfig config)? onApplyConfig;

  @override
  ConsumerState<DesktopLyricsSettingsTab> createState() =>
      _DesktopLyricsSettingsTabState();
}

class _DesktopLyricsSettingsTabState
    extends ConsumerState<DesktopLyricsSettingsTab> {
  static const DesktopLyricsConfig _fallbackDesktopLyricsConfig =
      DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: false,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(fontSize: 34),
        background: DesktopLyricsBackgroundConfig(opacity: 0.93),
        gradient: DesktopLyricsGradientConfig(),
        layout: DesktopLyricsLayoutConfig(overlayWidth: 980),
      );

  static const List<int> _palette = <int>[
    0xFFF2F2F8,
    0xFF121214,
    0xFFFFFFFF,
    0xFFFFD36E,
    0xFFFF4D8D,
    0xFF8CD867,
    0xFF4A78F0,
    0xFF220A35,
    0x00000000,
  ];

  DesktopLyricsConfig _currentConfig = _fallbackDesktopLyricsConfig;

  Future<void> _applyNative(DesktopLyricsConfig config) async {
    if (widget.onApplyConfig case final onApplyConfig?) {
      await onApplyConfig(config);
      return;
    }
    await ref.read(desktopLyricsClientProvider).apply(config);
  }

  void _preview(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) {
    final DesktopLyricsConfig next = transform(_currentConfig);
    setState(() {
      _currentConfig = next;
    });
    unawaited(_applyNative(next));
  }

  Future<void> _commit(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) async {
    final DesktopLyricsConfig next = transform(_currentConfig);
    _currentConfig = next;
    await ref.read(desktopLyricsSettingsProvider.notifier).updateConfig(next);
    await _applyNative(next);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _commitFromValue(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) {
    return _commit(transform);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<DesktopLyricsConfig> configAsync = ref.watch(
      desktopLyricsSettingsProvider,
    );
    final DesktopLyricsConfig config = switch (configAsync) {
      AsyncData(:final value) => _currentConfig = value,
      _ => _currentConfig,
    };

    final bool enabled = config.interaction.enabled;
    final bool clickThrough = config.interaction.clickThrough;
    final double fontSize = config.text.fontSize;
    final double strokeWidth = config.text.strokeWidth ?? 0.0;
    final TextAlign textAlign = config.text.textAlign ?? .start;
    final FontWeight fontWeight = config.text.fontWeight ?? .w400;
    final int textColor = config.text.textColor?.toARGB32() ?? 0xFFF2F2F8;
    final int shadowColor = config.text.shadowColor?.toARGB32() ?? 0xFF121214;
    final int strokeColor = config.text.strokeColor?.toARGB32() ?? 0x00000000;
    final double backgroundOpacity = config.background.opacity;
    final int backgroundColor =
        config.background.backgroundColor?.toARGB32() ?? 0x7A220A35;
    final int backgroundBaseColor = 0xFF000000 | (backgroundColor & 0x00FFFFFF);
    final bool gradientEnabled = config.gradient.textGradientEnabled;
    final int gradientStartColor =
        config.gradient.textGradientStartColor?.toARGB32() ?? 0xFFFFD36E;
    final int gradientEndColor =
        config.gradient.textGradientEndColor?.toARGB32() ?? 0xFFFF4D8D;
    final double overlayWidth = config.layout.overlayWidth ?? 980.0;

    return _DesktopLyricsSettingsSections(
      l10n: l10n,
      enabled: enabled,
      clickThrough: clickThrough,
      fontSize: fontSize,
      strokeWidth: strokeWidth,
      textAlign: textAlign,
      fontWeight: fontWeight,
      textColor: textColor,
      shadowColor: shadowColor,
      strokeColor: strokeColor,
      backgroundOpacity: backgroundOpacity,
      backgroundBaseColor: backgroundBaseColor,
      gradientEnabled: gradientEnabled,
      gradientStartColor: gradientStartColor,
      gradientEndColor: gradientEndColor,
      overlayWidth: overlayWidth,
      palette: _palette,
      preview: _preview,
      commit: _commitFromValue,
    );
  }
}
