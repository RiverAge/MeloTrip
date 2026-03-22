part of 'lyrics_settings.dart';

class _DesktopLyricsVisualSection extends StatelessWidget {
  const _DesktopLyricsVisualSection({
    required this.l10n,
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
  final double backgroundOpacity;
  final int backgroundBaseColor;
  final bool gradientEnabled;
  final int gradientStartColor;
  final int gradientEndColor;
  final double overlayWidth;
  final List<int> palette;
  final void Function(_DesktopLyricsTransform transform) preview;
  final Future<void> Function(_DesktopLyricsTransform transform) commit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        _buildBackgroundSection(),
        _buildGradientSection(),
        _buildLayoutSection(),
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
