import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_page.dart';
import 'package:melo_trip/pages/mobile/favorite/favorite_page.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/pages/mobile/settings/app_theme_page.dart';
import 'package:melo_trip/pages/mobile/settings/language_page.dart';
import 'package:melo_trip/pages/mobile/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/desktop_lyrics/desktop_lyrics.dart';

class DesktopSettingsPage extends ConsumerStatefulWidget {
  const DesktopSettingsPage({super.key});

  @override
  ConsumerState<DesktopSettingsPage> createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends ConsumerState<DesktopSettingsPage> {
  bool _enabled = true;
  bool _clickThrough = false;
  double _fontSize = 34;
  double _opacity = .93;
  double _strokeWidth = 0;

  int _textColor = 0xFFF2F2F8;
  int _shadowColor = 0xFF121214;
  int _strokeColor = 0x00000000;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(l10n.settings),
          surfaceTintColor: theme.colorScheme.surface.withValues(alpha: 0),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000 ? 2 : 1;
                final tiles = _buildTiles(context, l10n);
                return Column(
                  children: [
                    _DesktopLyricsConfigCard(
                      l10n: l10n,
                      enabled: _enabled,
                      clickThrough: _clickThrough,
                      fontSize: _fontSize,
                      opacity: _opacity,
                      strokeWidth: _strokeWidth,
                      textColor: _textColor,
                      shadowColor: _shadowColor,
                      strokeColor: _strokeColor,
                      onEnabledChanged: (v) async {
                        setState(() => _enabled = v);
                        await _pushLyricsConfig();
                      },
                      onClickThroughChanged: (v) async {
                        setState(() => _clickThrough = v);
                        await _pushLyricsConfig();
                      },
                      onFontSizeChanged: (v) {
                        setState(() => _fontSize = v);
                      },
                      onFontSizeChangeEnd: (v) async {
                        _fontSize = v;
                        await _pushLyricsConfig();
                      },
                      onOpacityChanged: (v) {
                        setState(() => _opacity = v);
                      },
                      onOpacityChangeEnd: (v) async {
                        _opacity = v;
                        await _pushLyricsConfig();
                      },
                      onStrokeWidthChanged: (v) {
                        setState(() => _strokeWidth = v);
                      },
                      onStrokeWidthChangeEnd: (v) async {
                        _strokeWidth = v;
                        await _pushLyricsConfig();
                      },
                      onTextColorChanged: (v) async {
                        setState(() => _textColor = v);
                        await _pushLyricsConfig();
                      },
                      onShadowColorChanged: (v) async {
                        setState(() => _shadowColor = v);
                        await _pushLyricsConfig();
                      },
                      onStrokeColorChanged: (v) async {
                        setState(() => _strokeColor = v);
                        await _pushLyricsConfig();
                      },
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tiles.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 2 ? 3.6 : 4.2,
                      ),
                      itemBuilder: (_, index) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 180 + index * 36),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset((1 - value) * 10, 0),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: _SettingActionTile(config: tiles[index]),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.errorContainer,
                foregroundColor: theme.colorScheme.onErrorContainer,
              ),
              onPressed: () => _onLogout(context, ref),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.logout),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pushLyricsConfig() async {
    await ref.read(desktopLyricsServiceProvider).updateConfig(
      DesktopLyricsConfig(
        enabled: _enabled,
        clickThrough: _clickThrough,
        fontSize: _fontSize,
        opacity: _opacity,
        textColorArgb: _textColor,
        shadowColorArgb: _shadowColor,
        strokeColorArgb: _strokeColor,
        strokeWidth: _strokeWidth,
      ),
    );
  }

  List<_SettingActionConfig> _buildTiles(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return [
      _SettingActionConfig(
        icon: Icons.contrast_rounded,
        title: l10n.theme,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AppThemePage()));
        },
      ),
      _SettingActionConfig(
        icon: Icons.high_quality_rounded,
        title: l10n.musicQuality,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => MusicQualityPage()));
        },
      ),
      _SettingActionConfig(
        icon: Icons.featured_play_list_outlined,
        title: l10n.myPlaylist,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DesktopPlaylistsPage()),
          );
        },
      ),
      _SettingActionConfig(
        icon: Icons.favorite_border_outlined,
        title: l10n.myFavorites,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const FavoritePage()));
        },
      ),
      _SettingActionConfig(
        icon: Icons.language_rounded,
        title: l10n.language,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LanguagePage()));
        },
      ),
    ];
  }

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutDialogConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;

    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.pause();
    await ref.read(logoutProvider.future);
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const InitialPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }
}

class _SettingActionConfig {
  const _SettingActionConfig({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
}

class _SettingActionTile extends StatelessWidget {
  const _SettingActionTile({required this.config});

  final _SettingActionConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: config.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(config.icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  config.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopLyricsConfigCard extends StatelessWidget {
  const _DesktopLyricsConfigCard({
    required this.l10n,
    required this.enabled,
    required this.clickThrough,
    required this.fontSize,
    required this.opacity,
    required this.strokeWidth,
    required this.textColor,
    required this.shadowColor,
    required this.strokeColor,
    required this.onEnabledChanged,
    required this.onClickThroughChanged,
    required this.onFontSizeChanged,
    required this.onFontSizeChangeEnd,
    required this.onOpacityChanged,
    required this.onOpacityChangeEnd,
    required this.onStrokeWidthChanged,
    required this.onStrokeWidthChangeEnd,
    required this.onTextColorChanged,
    required this.onShadowColorChanged,
    required this.onStrokeColorChanged,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final bool clickThrough;
  final double fontSize;
  final double opacity;
  final double strokeWidth;
  final int textColor;
  final int shadowColor;
  final int strokeColor;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onClickThroughChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onFontSizeChangeEnd;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onOpacityChangeEnd;
  final ValueChanged<double> onStrokeWidthChanged;
  final ValueChanged<double> onStrokeWidthChangeEnd;
  final ValueChanged<int> onTextColorChanged;
  final ValueChanged<int> onShadowColorChanged;
  final ValueChanged<int> onStrokeColorChanged;

  static const _textPalette = <int>[
    0xFFFFFFFF,
    0xFFF2F2F8,
    0xFFFAEFA8,
    0xFFBDE7FF,
  ];
  static const _shadowPalette = <int>[
    0xFF121214,
    0xFF000000,
    0xFF2C0E1A,
    0xFF1A2230,
  ];
  static const _strokePalette = <int>[
    0x00000000,
    0xFF000000,
    0xFFFFFFFF,
    0xFFDB1D5D,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                const Icon(Icons.lyrics_rounded),
                const SizedBox(width: 8),
                Text(
                  l10n.desktopLyrics,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: clickThrough,
              onChanged: enabled ? onClickThroughChanged : null,
              title: Text(l10n.desktopLyricsClickThrough),
            ),
            _SliderRow(
              label: l10n.desktopLyricsFontSize,
              valueText: fontSize.toStringAsFixed(0),
              value: fontSize,
              min: 20,
              max: 72,
              onChanged: enabled ? onFontSizeChanged : null,
              onChangeEnd: enabled ? onFontSizeChangeEnd : null,
            ),
            _SliderRow(
              label: l10n.desktopLyricsOpacity,
              valueText: '${(opacity * 100).toStringAsFixed(0)}%',
              value: opacity,
              min: .25,
              max: 1,
              onChanged: enabled ? onOpacityChanged : null,
              onChangeEnd: enabled ? onOpacityChangeEnd : null,
            ),
            _SliderRow(
              label: l10n.desktopLyricsStrokeWidth,
              valueText: strokeWidth.toStringAsFixed(1),
              value: strokeWidth,
              min: 0,
              max: 4,
              onChanged: enabled ? onStrokeWidthChanged : null,
              onChangeEnd: enabled ? onStrokeWidthChangeEnd : null,
            ),
            const SizedBox(height: 8),
            _ColorRow(
              label: l10n.desktopLyricsTextColor,
              selected: textColor,
              options: _textPalette,
              enabled: enabled,
              onSelected: onTextColorChanged,
            ),
            const SizedBox(height: 8),
            _ColorRow(
              label: l10n.desktopLyricsShadowColor,
              selected: shadowColor,
              options: _shadowPalette,
              enabled: enabled,
              onSelected: onShadowColorChanged,
            ),
            const SizedBox(height: 8),
            _ColorRow(
              label: l10n.desktopLyricsStrokeColor,
              selected: strokeColor,
              options: _strokePalette,
              enabled: enabled,
              onSelected: onStrokeColorChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text(valueText),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.enabled,
    required this.onSelected,
  });

  final String label;
  final int selected;
  final List<int> options;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, maxLines: 1, overflow: .ellipsis),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((color) {
              final isSelected = color == selected;
              return GestureDetector(
                onTap: enabled ? () => onSelected(color) : null,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
