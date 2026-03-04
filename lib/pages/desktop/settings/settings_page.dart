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
  ConsumerState<DesktopSettingsPage> createState() =>
      _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends ConsumerState<DesktopSettingsPage> {
  bool _enabled = true;
  bool _clickThrough = false;
  double _fontSize = 34;
  double _opacity = .93;
  double _strokeWidth = 0;
  bool _simulatingLyrics = false;
  bool _simulatingTokenLyrics = false;
  bool _gradientEnabled = true;
  double _backgroundOpacity = 0x7A / 255.0;
  double _overlayWidth = 980;
  double _overlayHeight = 160;
  bool _overlayHeightCustomized = false;
  TextAlign _textAlign = TextAlign.start;
  FontWeight _fontWeight = FontWeight.w400;

  int _textColor = 0xFFF2F2F8;
  int _shadowColor = 0xFF121214;
  int _strokeColor = 0x00000000;
  int _backgroundBaseColor = 0xFF220A35;
  int _gradientStartColor = 0xFFFFD36E;
  int _gradientEndColor = 0xFFFF4D8D;

  @override
  void initState() {
    super.initState();
    final state = ref.read(desktopLyricsServiceProvider).state;
    _enabled = state.enabled;
    _clickThrough = state.clickThrough;
    _fontSize = state.fontSize;
    _opacity = state.opacity;
    _strokeWidth = state.strokeWidth;
    _textAlign = state.textAlign;
    _fontWeight = _toFontWeight(state.fontWeightValue);
    _textColor = state.textColorArgb;
    _shadowColor = state.shadowColorArgb;
    _strokeColor = state.strokeColorArgb;
    _gradientEnabled = state.textGradientEnabled;
    _gradientStartColor = state.textGradientStartArgb;
    _gradientEndColor = state.textGradientEndArgb;
    _backgroundOpacity = ((state.backgroundColorArgb >> 24) & 0xFF) / 255.0;
    _backgroundBaseColor =
        0xFF000000 | (state.backgroundColorArgb & 0x00FFFFFF);
    _overlayWidth = state.overlayWidth;
    _overlayHeight = state.overlayHeight;
  }

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
                      textAlign: _textAlign,
                      fontWeight: _fontWeight,
                      onTextAlignChanged: (v) async {
                        setState(() => _textAlign = v);
                        await _pushLyricsConfig();
                      },
                      onFontWeightChanged: (v) async {
                        setState(() => _fontWeight = v);
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
                      backgroundBaseColor: _backgroundBaseColor,
                      backgroundOpacity: _backgroundOpacity,
                      onBackgroundBaseColorChanged: (v) async {
                        setState(() => _backgroundBaseColor = v);
                        await _pushLyricsConfig();
                      },
                      onBackgroundOpacityChanged: (v) {
                        setState(() => _backgroundOpacity = v);
                      },
                      onBackgroundOpacityChangeEnd: (v) async {
                        _backgroundOpacity = v;
                        await _pushLyricsConfig();
                      },
                      gradientEnabled: _gradientEnabled,
                      gradientStartColor: _gradientStartColor,
                      gradientEndColor: _gradientEndColor,
                      onGradientEnabledChanged: (v) async {
                        setState(() => _gradientEnabled = v);
                        await _pushLyricsConfig();
                      },
                      onGradientStartColorChanged: (v) async {
                        setState(() => _gradientStartColor = v);
                        await _pushLyricsConfig();
                      },
                      onGradientEndColorChanged: (v) async {
                        setState(() => _gradientEndColor = v);
                        await _pushLyricsConfig();
                      },
                      overlayWidth: _overlayWidth,
                      overlayHeight: _overlayHeight,
                      onOverlayWidthChanged: (v) {
                        setState(() => _overlayWidth = v);
                      },
                      onOverlayWidthChangeEnd: (v) async {
                        _overlayWidth = v;
                        await _pushLyricsConfig();
                      },
                      onOverlayHeightChanged: (v) {
                        setState(() => _overlayHeight = v);
                      },
                      onOverlayHeightChangeEnd: (v) async {
                        _overlayHeight = v;
                        _overlayHeightCustomized = true;
                        await _pushLyricsConfig();
                      },
                      simulatingLyrics: _simulatingLyrics,
                      onSimulatePressed: _runLyricsSimulation,
                      simulatingTokenLyrics: _simulatingTokenLyrics,
                      onSimulateTokenPressed: _runTokenLyricsSimulation,
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
    await ref
        .read(desktopLyricsServiceProvider)
        .configure(
          DesktopLyricsConfig(
            interaction: DesktopLyricsInteractionConfig(
              enabled: _enabled,
              clickThrough: _clickThrough,
            ),
            text: DesktopLyricsTextConfig(
              fontSize: _fontSize,
              textColor: Color(_textColor),
              shadowColor: Color(_shadowColor),
              strokeColor: Color(_strokeColor),
              strokeWidth: _strokeWidth,
              fontFamily: 'Segoe UI',
          textAlign: _textAlign,
          fontWeight: _fontWeight,
        ),
            opacity: _opacity,
            background: DesktopLyricsBackgroundConfig(
              backgroundColor: Color(
                ((255 * _backgroundOpacity).round() << 24) |
                    (_backgroundBaseColor & 0x00FFFFFF),
              ),
              backgroundRadius: 22,
              backgroundPadding: 12,
            ),
            gradient: DesktopLyricsGradientConfig(
              textGradientEnabled: _gradientEnabled,
              textGradientStartColor: Color(_gradientStartColor),
              textGradientEndColor: Color(_gradientEndColor),
              textGradientAngle: 0,
            ),
            layout: DesktopLyricsLayoutConfig(
              overlayWidth: _overlayWidth,
              overlayHeight: _overlayHeightCustomized ? _overlayHeight : null,
            ),
          ),
        );
  }

  FontWeight _toFontWeight(int value) {
    final clamped = value.clamp(100, 900);
    switch (clamped) {
      case >= 800:
        return FontWeight.w800;
      case >= 700:
        return FontWeight.w700;
      case >= 600:
        return FontWeight.w600;
      case >= 500:
        return FontWeight.w500;
      case >= 400:
        return FontWeight.w400;
      case >= 300:
        return FontWeight.w300;
      case >= 200:
        return FontWeight.w200;
      default:
        return FontWeight.w100;
    }
  }

  Future<void> _runLyricsSimulation() async {
    if (_simulatingLyrics) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _simulatingLyrics = true);
    final service = ref.read(desktopLyricsServiceProvider);
    await service.show();
    final previewText = '${l10n.play} ${l10n.desktopLyrics} ${l10n.playQueue}';
    for (var i = 1; i <= previewText.length; i++) {
      if (!mounted) return;
      await service.render(
        DesktopLyricsFrame.fromTimedTokens(
          lineProgress: 1.0,
          tokens: [DesktopLyricsTokenTiming(text: previewText.substring(0, i), durationMs: 1)],
        ),
      );
      await Future.delayed(const Duration(milliseconds: 45));
    }
    if (mounted) setState(() => _simulatingLyrics = false);
  }

  Future<void> _runTokenLyricsSimulation() async {
    if (_simulatingTokenLyrics) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _simulatingTokenLyrics = true);
    final service = ref.read(desktopLyricsServiceProvider);
    await service.show();
    final tokens = <String>[
      '${l10n.desktopLyrics} ${l10n.desktopLyrics}',
      'Hi',
      l10n.playQueue,
    ];
    final buffer = StringBuffer();
    for (var tokenIndex = 0; tokenIndex < tokens.length; tokenIndex++) {
      final token = tokens[tokenIndex];
      for (var i = 1; i <= token.length; i++) {
        if (!mounted) return;
        final prefix = buffer.toString();
        final current = token.substring(0, i);
        final line = prefix.isEmpty ? current : '$prefix $current';
        await service.render(DesktopLyricsFrame.line(currentLine: line));
        await Future.delayed(const Duration(milliseconds: 45));
      }
      if (buffer.isEmpty) {
        buffer.write(token);
      } else {
        buffer.write(' $token');
      }
      if (!mounted) return;
      await service.render(DesktopLyricsFrame.line(currentLine: buffer.toString()));
      await Future.delayed(
        Duration(milliseconds: tokenIndex == tokens.length - 1 ? 140 : 220),
      );
    }
    if (mounted) setState(() => _simulatingTokenLyrics = false);
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
    required this.textAlign,
    required this.fontWeight,
    required this.onTextAlignChanged,
    required this.onFontWeightChanged,
    required this.onTextColorChanged,
    required this.onShadowColorChanged,
    required this.onStrokeColorChanged,
    required this.backgroundBaseColor,
    required this.backgroundOpacity,
    required this.onBackgroundBaseColorChanged,
    required this.onBackgroundOpacityChanged,
    required this.onBackgroundOpacityChangeEnd,
    required this.gradientEnabled,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.onGradientEnabledChanged,
    required this.onGradientStartColorChanged,
    required this.onGradientEndColorChanged,
    required this.overlayWidth,
    required this.overlayHeight,
    required this.onOverlayWidthChanged,
    required this.onOverlayWidthChangeEnd,
    required this.onOverlayHeightChanged,
    required this.onOverlayHeightChangeEnd,
    required this.simulatingLyrics,
    required this.onSimulatePressed,
    required this.simulatingTokenLyrics,
    required this.onSimulateTokenPressed,
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
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final ValueChanged<TextAlign> onTextAlignChanged;
  final ValueChanged<FontWeight> onFontWeightChanged;
  final ValueChanged<int> onTextColorChanged;
  final ValueChanged<int> onShadowColorChanged;
  final ValueChanged<int> onStrokeColorChanged;
  final int backgroundBaseColor;
  final double backgroundOpacity;
  final ValueChanged<int> onBackgroundBaseColorChanged;
  final ValueChanged<double> onBackgroundOpacityChanged;
  final ValueChanged<double> onBackgroundOpacityChangeEnd;
  final bool gradientEnabled;
  final int gradientStartColor;
  final int gradientEndColor;
  final ValueChanged<bool> onGradientEnabledChanged;
  final ValueChanged<int> onGradientStartColorChanged;
  final ValueChanged<int> onGradientEndColorChanged;
  final double overlayWidth;
  final double overlayHeight;
  final ValueChanged<double> onOverlayWidthChanged;
  final ValueChanged<double> onOverlayWidthChangeEnd;
  final ValueChanged<double> onOverlayHeightChanged;
  final ValueChanged<double> onOverlayHeightChangeEnd;
  final bool simulatingLyrics;
  final Future<void> Function() onSimulatePressed;
  final bool simulatingTokenLyrics;
  final Future<void> Function() onSimulateTokenPressed;

  static const _textPalette = <int>[
    0xFFFFFFFF,
    0xFFF2F2F8,
    0xFFFAEFA8,
    0xFFBDE7FF,
  ];
  static const _shadowPalette = <int>[
    0x00000000,
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
  static const _backgroundPalette = <int>[
    0xFF220A35,
    0xFF102030,
    0xFF2A1422,
    0xFF15301D,
    0xFF301D12,
    0xFF1C1C1F,
  ];
  static const _gradientPalette = <int>[
    0xFFFFD36E,
    0xFFFF4D8D,
    0xFF82D4FF,
    0xFF5BF1D4,
    0xFFFFAA00,
    0xFF9A7CFF,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                Switch(value: enabled, onChanged: onEnabledChanged),
              ],
            ),
            const SizedBox(height: 10),
            Card.outlined(
              margin: EdgeInsets.zero,
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: clickThrough,
                  onChanged: enabled ? onClickThroughChanged : null,
                  title: Text(l10n.desktopLyricsClickThrough),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: l10n.desktopLyricsSectionText,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _SliderRow(
                    label: l10n.desktopLyricsFontSize,
                    valueText: fontSize.toStringAsFixed(0),
                    value: fontSize,
                    min: 20,
                    max: 172,
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
                  const SizedBox(height: 6),
                  Text(
                    l10n.desktopLyricsFontWeight,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: .centerLeft,
                    child: SegmentedButton<FontWeight>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment<FontWeight>(
                          value: FontWeight.w400,
                          label: Text('400'),
                        ),
                        ButtonSegment<FontWeight>(
                          value: FontWeight.w500,
                          label: Text('500'),
                        ),
                        ButtonSegment<FontWeight>(
                          value: FontWeight.w600,
                          label: Text('600'),
                        ),
                        ButtonSegment<FontWeight>(
                          value: FontWeight.w700,
                          label: Text('700'),
                        ),
                      ],
                      selected: {fontWeight},
                      onSelectionChanged: enabled
                          ? (values) => onFontWeightChanged(values.first)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.desktopLyricsTextAlign,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: .centerLeft,
                    child: SegmentedButton<TextAlign>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment<TextAlign>(
                          value: TextAlign.start,
                          icon: Icon(Icons.format_align_left_rounded),
                        ),
                        ButtonSegment<TextAlign>(
                          value: TextAlign.center,
                          icon: Icon(Icons.format_align_center_rounded),
                        ),
                        ButtonSegment<TextAlign>(
                          value: TextAlign.end,
                          icon: Icon(Icons.format_align_right_rounded),
                        ),
                      ],
                      selected: {textAlign},
                      onSelectionChanged: enabled
                          ? (values) => onTextAlignChanged(values.first)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ColorRow(
                    label: l10n.desktopLyricsTextColor,
                    selected: textColor,
                    options: _textPalette,
                    enabled: enabled && !gradientEnabled,
                    onSelected: onTextColorChanged,
                  ),
                  if (gradientEnabled)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l10n.desktopLyricsGradientOverrideHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
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
            const SizedBox(height: 10),
            _SectionCard(
              title: l10n.desktopLyricsSectionBackground,
              child: Column(
                children: [
                  _ColorRow(
                    label: l10n.desktopLyricsBackgroundColor,
                    selected: backgroundBaseColor,
                    options: _backgroundPalette,
                    enabled: enabled,
                    onSelected: onBackgroundBaseColorChanged,
                  ),
                  _SliderRow(
                    label: l10n.desktopLyricsBackgroundOpacity,
                    valueText:
                        '${(backgroundOpacity * 100).toStringAsFixed(0)}%',
                    value: backgroundOpacity,
                    min: 0,
                    max: 1,
                    onChanged: enabled ? onBackgroundOpacityChanged : null,
                    onChangeEnd: enabled ? onBackgroundOpacityChangeEnd : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: l10n.desktopLyricsSectionGradient,
              child: Column(
                children: [
                  SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: gradientEnabled,
                    onChanged: enabled ? onGradientEnabledChanged : null,
                    title: Text(l10n.desktopLyricsGradientEnabled),
                  ),
                  _ColorRow(
                    label: l10n.desktopLyricsGradientStartColor,
                    selected: gradientStartColor,
                    options: _gradientPalette,
                    enabled: enabled && gradientEnabled,
                    onSelected: onGradientStartColorChanged,
                  ),
                  const SizedBox(height: 8),
                  _ColorRow(
                    label: l10n.desktopLyricsGradientEndColor,
                    selected: gradientEndColor,
                    options: _gradientPalette,
                    enabled: enabled && gradientEnabled,
                    onSelected: onGradientEndColorChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: l10n.desktopLyricsSectionLayout,
              child: Column(
                children: [
                  _SliderRow(
                    label: l10n.desktopLyricsOverlayWidth,
                    valueText: overlayWidth.toStringAsFixed(0),
                    value: overlayWidth,
                    min: 480,
                    max: 1800,
                    onChanged: enabled ? onOverlayWidthChanged : null,
                    onChangeEnd: enabled ? onOverlayWidthChangeEnd : null,
                  ),
                  _SliderRow(
                    label: l10n.desktopLyricsOverlayHeight,
                    valueText: overlayHeight.toStringAsFixed(0),
                    value: overlayHeight,
                    min: 90,
                    max: 420,
                    onChanged: enabled ? onOverlayHeightChanged : null,
                    onChangeEnd: enabled ? onOverlayHeightChangeEnd : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: l10n.desktopLyricsSectionPreview,
              child: Align(
                alignment: .centerRight,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: enabled && !simulatingLyrics
                          ? onSimulatePressed
                          : null,
                      icon: Icon(
                        simulatingLyrics
                            ? Icons.hourglass_top_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text('${l10n.play} ${l10n.desktopLyrics}'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: enabled && !simulatingTokenLyrics
                          ? onSimulateTokenPressed
                          : null,
                      icon: Icon(
                        simulatingTokenLyrics
                            ? Icons.hourglass_top_rounded
                            : Icons.text_fields_rounded,
                      ),
                      label: Text(l10n.desktopLyricsTokenPreview),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.outlined(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _SectionLabel(title: title),
            const SizedBox(height: 2),
            Align(alignment: .centerLeft, child: child),
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
    final theme = Theme.of(context);
    final disabled = onChanged == null;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: disabled
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.55)
                      : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: disabled ? 0.35 : 0.6,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                valueText,
                style: theme.textTheme.labelMedium,
              ),
            ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((color) {
            final isSelected = color == selected;
            return GestureDetector(
              onTap: enabled ? () => onSelected(color) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Color(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
