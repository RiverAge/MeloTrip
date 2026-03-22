part of 'lyrics_settings.dart';

class _DesktopLyricsSettingsSections extends StatelessWidget {
  const _DesktopLyricsSettingsSections({
    required this.l10n,
    required this.enabled,
    required this.clickThrough,
    required this.fontSize,
    required this.strokeWidth,
    required this.textAlign,
    required this.fontWeight,
    required this.textColor,
    required this.shadowColor,
    required this.strokeColor,
    required this.backgroundOpacity,
    required this.backgroundBaseColor,
    required this.gradientEnabled,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.overlayWidth,
    required this.palette,
    required this.preview,
    required this.commit,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final bool clickThrough;
  final double fontSize;
  final double strokeWidth;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int textColor;
  final int shadowColor;
  final int strokeColor;
  final double backgroundOpacity;
  final int backgroundBaseColor;
  final bool gradientEnabled;
  final int gradientStartColor;
  final int gradientEndColor;
  final double overlayWidth;
  final List<int> palette;
  final void Function(DesktopLyricsConfig Function(DesktopLyricsConfig config))
  preview;
  final Future<void> Function(
    DesktopLyricsConfig Function(DesktopLyricsConfig config),
  )
  commit;

  @override
  Widget build(BuildContext context) {
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
                _buildInteractionSection(),
                _buildTextSection(),
                _buildBackgroundSection(),
                _buildGradientSection(),
                _buildLayoutSection(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionSection() {
    return Column(
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
                  onChanged: (bool value) => commit(
                    (DesktopLyricsConfig c) => c.copyWith(
                      interaction: c.interaction.copyWith(enabled: value),
                    ),
                  ),
                ),
              ),
              SettingRow(
                label: l10n.desktopLyricsClickThrough,
                description: '',
                trailing: Switch(
                  value: clickThrough,
                  onChanged: (bool value) => commit(
                    (DesktopLyricsConfig c) => c.copyWith(
                      interaction: c.interaction.copyWith(clickThrough: value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextSection() {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
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
                onPreviewChanged: (double value) => preview(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(fontSize: value)),
                ),
                onSubmitted: (double value) => commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(fontSize: value)),
                ),
              ),
              SettingSliderRow(
                label: l10n.desktopLyricsStrokeWidth,
                value: strokeWidth,
                min: 0,
                max: 6,
                onPreviewChanged: (double value) => preview(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(strokeWidth: value)),
                ),
                onSubmitted: (double value) => commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(strokeWidth: value)),
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
                onChanged: (TextAlign value) => commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(textAlign: value)),
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
                onChanged: (FontWeight value) => commit(
                  (DesktopLyricsConfig c) =>
                      c.copyWith(text: c.text.copyWith(fontWeight: value)),
                ),
              ),
              SettingColorRow(
                label: l10n.desktopLyricsTextColor,
                value: textColor,
                palette: palette,
                onChanged: (int value) => commit(
                  (DesktopLyricsConfig c) => c.copyWith(
                    text: c.text.copyWith(textColor: Color(value)),
                  ),
                ),
              ),
              SettingColorRow(
                label: l10n.desktopLyricsShadowColor,
                value: shadowColor,
                palette: palette,
                onChanged: (int value) => commit(
                  (DesktopLyricsConfig c) => c.copyWith(
                    text: c.text.copyWith(shadowColor: Color(value)),
                  ),
                ),
              ),
              SettingColorRow(
                label: l10n.desktopLyricsStrokeColor,
                value: strokeColor,
                palette: palette,
                onChanged: (int value) => commit(
                  (DesktopLyricsConfig c) => c.copyWith(
                    text: c.text.copyWith(strokeColor: Color(value)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundSection() {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
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
                onPreviewChanged: (double value) => preview(
                  (DesktopLyricsConfig c) => c.copyWith(
                    background: c.background.copyWith(opacity: value),
                  ),
                ),
                onSubmitted: (double value) => commit(
                  (DesktopLyricsConfig c) => c.copyWith(
                    background: c.background.copyWith(opacity: value),
                  ),
                ),
              ),
              SettingColorRow(
                label: l10n.desktopLyricsBackgroundColor,
                value: backgroundBaseColor,
                palette: palette,
                onChanged: (int value) => commit((DesktopLyricsConfig c) {
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
      ],
    );
  }

  Widget _buildGradientSection() {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
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
                  onChanged: (bool value) => commit(
                    (DesktopLyricsConfig c) => c.copyWith(
                      gradient: c.gradient.copyWith(textGradientEnabled: value),
                    ),
                  ),
                ),
              ),
              SettingColorRow(
                label: l10n.desktopLyricsGradientStartColor,
                value: gradientStartColor,
                palette: palette,
                onChanged: (int value) => commit(
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
                palette: palette,
                onChanged: (int value) => commit(
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
      ],
    );
  }

  Widget _buildLayoutSection() {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
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
                onPreviewChanged: (double value) => preview(
                  (DesktopLyricsConfig c) => c.copyWith(
                    layout: c.layout.copyWith(overlayWidth: value),
                  ),
                ),
                onSubmitted: (double value) => commit(
                  (DesktopLyricsConfig c) => c.copyWith(
                    layout: c.layout.copyWith(overlayWidth: value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
