import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/provider/desktop/desktop_lyrics_client.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';

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

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: <Widget>[
        SettingSectionHeader(title: l10n.desktopLyrics),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingRow(
            label: l10n.desktopLyricsEnabled,
            description: '',
            trailing: Switch(
              value: enabled,
              onChanged: (bool value) => _commit(
                (DesktopLyricsConfig c) => c.copyWith(
                  interaction: c.interaction.copyWith(enabled: value),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingRow(
            label: l10n.desktopLyricsClickThrough,
            description: '',
            trailing: Switch(
              value: clickThrough,
              onChanged: (bool value) => _commit(
                (DesktopLyricsConfig c) => c.copyWith(
                  interaction: c.interaction.copyWith(clickThrough: value),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 40),
        SettingSectionHeader(title: l10n.desktopLyricsSectionText),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingSliderRow(
            label: l10n.desktopLyricsFontSize,
            value: fontSize,
            min: 20,
            max: 72,
            onPreviewChanged: (double value) => _preview(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(fontSize: value)),
            ),
            onSubmitted: (double value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(fontSize: value)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingSliderRow(
            label: l10n.desktopLyricsStrokeWidth,
            value: strokeWidth,
            min: 0,
            max: 6,
            onPreviewChanged: (double value) => _preview(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(strokeWidth: value)),
            ),
            onSubmitted: (double value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(strokeWidth: value)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingRow(
            label: l10n.desktopLyricsTextAlign,
            description: '',
            trailing: DropdownButton<TextAlign>(
              value: textAlign,
              items: <DropdownMenuItem<TextAlign>>[
                DropdownMenuItem(
                  value: .start,
                  child: Text(l10n.textAlignStart),
                ),
                DropdownMenuItem(
                  value: .center,
                  child: Text(l10n.textAlignCenter),
                ),
                DropdownMenuItem(
                  value: .end,
                  child: Text(l10n.textAlignEnd),
                ),
              ],
              onChanged: (TextAlign? value) {
                if (value == null) {
                  return;
                }
                _commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(textAlign: value)),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingRow(
            label: l10n.desktopLyricsFontWeight,
            description: '',
            trailing: DropdownButton<FontWeight>(
              value: fontWeight,
              items: <DropdownMenuItem<FontWeight>>[
                DropdownMenuItem(
                  value: .w300,
                  child: Text(l10n.fontWeightW300),
                ),
                DropdownMenuItem(
                  value: .w400,
                  child: Text(l10n.fontWeightW400),
                ),
                DropdownMenuItem(
                  value: .w500,
                  child: Text(l10n.fontWeightW500),
                ),
                DropdownMenuItem(
                  value: .w600,
                  child: Text(l10n.fontWeightW600),
                ),
                DropdownMenuItem(
                  value: .w700,
                  child: Text(l10n.fontWeightW700),
                ),
              ],
              onChanged: (FontWeight? value) {
                if (value == null) {
                  return;
                }
                _commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(fontWeight: value)),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsTextColor,
            value: textColor,
            palette: _palette,
            onChanged: (int value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(textColor: Color(value))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsShadowColor,
            value: shadowColor,
            palette: _palette,
            onChanged: (int value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(shadowColor: Color(value))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsStrokeColor,
            value: strokeColor,
            palette: _palette,
            onChanged: (int value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(text: c.text.copyWith(strokeColor: Color(value))),
            ),
          ),
        ),
        const Divider(height: 40),
        SettingSectionHeader(title: l10n.desktopLyricsSectionBackground),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingSliderRow(
            label: l10n.desktopLyricsOpacity,
            value: backgroundOpacity,
            min: 0,
            max: 1,
            onPreviewChanged: (double value) => _preview(
              (DesktopLyricsConfig c) =>
                  c.copyWith(background: c.background.copyWith(opacity: value)),
            ),
            onSubmitted: (double value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(background: c.background.copyWith(opacity: value)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsBackgroundColor,
            value: backgroundBaseColor,
            palette: _palette,
            onChanged: (int value) => _commit((DesktopLyricsConfig c) {
              final int alpha =
                  ((c.background.backgroundColor?.toARGB32() ?? 0x7A220A35) >>
                      24) &
                  0xFF;
              final int color = (alpha << 24) | (value & 0x00FFFFFF);
              return c.copyWith(
                background: c.background.copyWith(
                  backgroundColor: Color(color),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 40),
        SettingSectionHeader(title: l10n.desktopLyricsSectionGradient),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingRow(
            label: l10n.desktopLyricsGradientEnabled,
            description: l10n.desktopLyricsGradientOverrideHint,
            trailing: Switch(
              value: gradientEnabled,
              onChanged: (bool value) => _commit(
                (DesktopLyricsConfig c) => c.copyWith(
                  gradient: c.gradient.copyWith(textGradientEnabled: value),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsGradientStartColor,
            value: gradientStartColor,
            palette: _palette,
            onChanged: (int value) => _commit(
              (DesktopLyricsConfig c) => c.copyWith(
                gradient: c.gradient.copyWith(
                  textGradientStartColor: Color(value),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingColorRow(
            label: l10n.desktopLyricsGradientEndColor,
            value: gradientEndColor,
            palette: _palette,
            onChanged: (int value) => _commit(
              (DesktopLyricsConfig c) => c.copyWith(
                gradient: c.gradient.copyWith(
                  textGradientEndColor: Color(value),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 40),
        SettingSectionHeader(title: l10n.desktopLyricsSectionLayout),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SettingSliderRow(
            label: l10n.desktopLyricsOverlayWidth,
            value: overlayWidth,
            min: 480,
            max: 1800,
            onPreviewChanged: (double value) => _preview(
              (DesktopLyricsConfig c) =>
                  c.copyWith(layout: c.layout.copyWith(overlayWidth: value)),
            ),
            onSubmitted: (double value) => _commit(
              (DesktopLyricsConfig c) =>
                  c.copyWith(layout: c.layout.copyWith(overlayWidth: value)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
