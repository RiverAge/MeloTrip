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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: <Widget>[
        Align(
          alignment: .topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                SettingSectionHeader(
                  title: l10n.desktopLyrics,
                  icon: Icons.lyrics_outlined,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingRow(
                        label: l10n.desktopLyricsEnabled,
                        description: '',
                        trailing: Switch(
                          value: enabled,
                          onChanged: (bool value) => _commit(
                            (DesktopLyricsConfig c) => c.copyWith(
                              interaction:
                                  c.interaction.copyWith(enabled: value),
                            ),
                          ),
                        ),
                      ),
                      SettingRow(
                        label: l10n.desktopLyricsClickThrough,
                        description: '',
                        trailing: Switch(
                          value: clickThrough,
                          onChanged: (bool value) => _commit(
                            (DesktopLyricsConfig c) => c.copyWith(
                              interaction:
                                  c.interaction.copyWith(clickThrough: value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingSectionHeader(
                  title: l10n.desktopLyricsSectionText,
                  icon: Icons.text_fields_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingSliderRow(
                        label: l10n.desktopLyricsFontSize,
                        value: fontSize,
                        min: 20,
                        max: 72,
                        onPreviewChanged: (double value) => _preview(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(fontSize: value),
                          ),
                        ),
                        onSubmitted: (double value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(fontSize: value),
                          ),
                        ),
                      ),
                      SettingSliderRow(
                        label: l10n.desktopLyricsStrokeWidth,
                        value: strokeWidth,
                        min: 0,
                        max: 6,
                        onPreviewChanged: (double value) => _preview(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(strokeWidth: value),
                          ),
                        ),
                        onSubmitted: (double value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(strokeWidth: value),
                          ),
                        ),
                      ),
                      SettingSingleChoiceRow<TextAlign>(
                        label: l10n.desktopLyricsTextAlign,
                        value: textAlign,
                        options: <SettingSingleChoiceOption<TextAlign>>[
                          SettingSingleChoiceOption<TextAlign>(
                            value: .start,
                            label: l10n.textAlignStart,
                            icon: Icons.format_align_left_rounded,
                          ),
                          SettingSingleChoiceOption<TextAlign>(
                            value: .center,
                            label: l10n.textAlignCenter,
                            icon: Icons.format_align_center_rounded,
                          ),
                          SettingSingleChoiceOption<TextAlign>(
                            value: .end,
                            label: l10n.textAlignEnd,
                            icon: Icons.format_align_right_rounded,
                          ),
                        ],
                        onChanged: (TextAlign value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(textAlign: value),
                          ),
                        ),
                      ),
                      SettingSingleChoiceRow<FontWeight>(
                        label: l10n.desktopLyricsFontWeight,
                        value: fontWeight,
                        options: <SettingSingleChoiceOption<FontWeight>>[
                          SettingSingleChoiceOption<FontWeight>(
                            value: .w300,
                            label: l10n.fontWeightW300,
                          ),
                          SettingSingleChoiceOption<FontWeight>(
                            value: .w400,
                            label: l10n.fontWeightW400,
                          ),
                          SettingSingleChoiceOption<FontWeight>(
                            value: .w500,
                            label: l10n.fontWeightW500,
                          ),
                          SettingSingleChoiceOption<FontWeight>(
                            value: .w600,
                            label: l10n.fontWeightW600,
                          ),
                          SettingSingleChoiceOption<FontWeight>(
                            value: .w700,
                            label: l10n.fontWeightW700,
                          ),
                        ],
                        onChanged: (FontWeight value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(fontWeight: value),
                          ),
                        ),
                      ),
                      SettingColorRow(
                        label: l10n.desktopLyricsTextColor,
                        value: textColor,
                        palette: _palette,
                        onChanged: (int value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(textColor: Color(value)),
                          ),
                        ),
                      ),
                      SettingColorRow(
                        label: l10n.desktopLyricsShadowColor,
                        value: shadowColor,
                        palette: _palette,
                        onChanged: (int value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(shadowColor: Color(value)),
                          ),
                        ),
                      ),
                      SettingColorRow(
                        label: l10n.desktopLyricsStrokeColor,
                        value: strokeColor,
                        palette: _palette,
                        onChanged: (int value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            text: c.text.copyWith(strokeColor: Color(value)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingSectionHeader(
                  title: l10n.desktopLyricsSectionBackground,
                  icon: Icons.wallpaper_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingSliderRow(
                        label: l10n.desktopLyricsOpacity,
                        value: backgroundOpacity,
                        min: 0,
                        max: 1,
                        onPreviewChanged: (double value) => _preview(
                          (DesktopLyricsConfig c) => c.copyWith(
                            background: c.background.copyWith(opacity: value),
                          ),
                        ),
                        onSubmitted: (double value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            background: c.background.copyWith(opacity: value),
                          ),
                        ),
                      ),
                      SettingColorRow(
                        label: l10n.desktopLyricsBackgroundColor,
                        value: backgroundBaseColor,
                        palette: _palette,
                        onChanged: (int value) => _commit((DesktopLyricsConfig c) {
                          final int alpha =
                              ((c.background.backgroundColor?.toARGB32() ??
                                          0x7A220A35) >>
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
                    ],
                  ),
                ),
                SettingSectionHeader(
                  title: l10n.desktopLyricsSectionGradient,
                  icon: Icons.gradient_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingRow(
                        label: l10n.desktopLyricsGradientEnabled,
                        description: l10n.desktopLyricsGradientOverrideHint,
                        trailing: Switch(
                          value: gradientEnabled,
                          onChanged: (bool value) => _commit(
                            (DesktopLyricsConfig c) => c.copyWith(
                              gradient: c.gradient.copyWith(
                                textGradientEnabled: value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SettingColorRow(
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
                      SettingColorRow(
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
                    ],
                  ),
                ),
                SettingSectionHeader(
                  title: l10n.desktopLyricsSectionLayout,
                  icon: Icons.layers_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingSliderRow(
                        label: l10n.desktopLyricsOverlayWidth,
                        value: overlayWidth,
                        min: 480,
                        max: 1800,
                        onPreviewChanged: (double value) => _preview(
                          (DesktopLyricsConfig c) => c.copyWith(
                            layout: c.layout.copyWith(overlayWidth: value),
                          ),
                        ),
                        onSubmitted: (double value) => _commit(
                          (DesktopLyricsConfig c) => c.copyWith(
                            layout: c.layout.copyWith(overlayWidth: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
