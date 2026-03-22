part of 'lyrics_settings.dart';

typedef _DesktopLyricsTransform =
    DesktopLyricsConfig Function(DesktopLyricsConfig config);

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
  final void Function(_DesktopLyricsTransform transform) preview;
  final Future<void> Function(_DesktopLyricsTransform transform) commit;

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
                _DesktopLyricsInteractionSection(
                  l10n: l10n,
                  enabled: enabled,
                  clickThrough: clickThrough,
                  commit: commit,
                ),
                _DesktopLyricsTextSection(
                  l10n: l10n,
                  fontSize: fontSize,
                  strokeWidth: strokeWidth,
                  textAlign: textAlign,
                  fontWeight: fontWeight,
                  textColor: textColor,
                  shadowColor: shadowColor,
                  strokeColor: strokeColor,
                  palette: palette,
                  preview: preview,
                  commit: commit,
                ),
                _DesktopLyricsVisualSection(
                  l10n: l10n,
                  backgroundOpacity: backgroundOpacity,
                  backgroundBaseColor: backgroundBaseColor,
                  gradientEnabled: gradientEnabled,
                  gradientStartColor: gradientStartColor,
                  gradientEndColor: gradientEndColor,
                  overlayWidth: overlayWidth,
                  palette: palette,
                  preview: preview,
                  commit: commit,
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
