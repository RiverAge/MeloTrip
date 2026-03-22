part of 'lyrics_settings.dart';

class _DesktopLyricsTextSection extends StatelessWidget {
  const _DesktopLyricsTextSection({
    required this.l10n,
    required this.fontSize,
    required this.strokeWidth,
    required this.textAlign,
    required this.fontWeight,
    required this.textColor,
    required this.shadowColor,
    required this.strokeColor,
    required this.palette,
    required this.preview,
    required this.commit,
  });

  final AppLocalizations l10n;
  final double fontSize;
  final double strokeWidth;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int textColor;
  final int shadowColor;
  final int strokeColor;
  final List<int> palette;
  final void Function(_DesktopLyricsTransform transform) preview;
  final Future<void> Function(_DesktopLyricsTransform transform) commit;

  @override
  Widget build(BuildContext context) {
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
}
