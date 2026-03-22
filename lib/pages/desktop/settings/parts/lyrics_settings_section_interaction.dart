part of 'lyrics_settings.dart';

class _DesktopLyricsInteractionSection extends StatelessWidget {
  const _DesktopLyricsInteractionSection({
    required this.l10n,
    required this.enabled,
    required this.clickThrough,
    required this.commit,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final bool clickThrough;
  final Future<void> Function(_DesktopLyricsTransform transform) commit;

  @override
  Widget build(BuildContext context) {
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
}
