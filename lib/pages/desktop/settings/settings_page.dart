import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/advanced_settings.dart';
import 'package:melo_trip/pages/desktop/settings/parts/appearance_settings.dart';
import 'package:melo_trip/pages/desktop/settings/parts/general_settings.dart';
import 'package:melo_trip/pages/desktop/settings/parts/lyrics_settings.dart';
import 'package:melo_trip/pages/desktop/settings/parts/playback_settings.dart';

class DesktopSettingsPage extends ConsumerStatefulWidget {
  const DesktopSettingsPage({super.key});

  @override
  ConsumerState<DesktopSettingsPage> createState() =>
      _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends ConsumerState<DesktopSettingsPage> {
  List<String> _tabTitles(AppLocalizations l10n) => <String>[
    l10n.settingsTabGeneral,
    l10n.settingsTabAppearance,
    l10n.settingsTabPlayback,
    l10n.settingsTabLyrics,
    l10n.settingsTabHotkeys,
    l10n.settingsTabAdvanced,
  ];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final List<String> tabTitles = _tabTitles(l10n);

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.94),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -140,
              right: -90,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                        theme.colorScheme.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                  child: const SizedBox(width: 360, height: 360),
                ),
              ),
            ),
            Align(
              alignment: .topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    _buildHeader(context, l10n, tabTitles),
                    _buildTabBar(context, tabTitles),
                    const SizedBox(height: 18),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          const GeneralSettings(),
                          const AppearanceSettings(),
                          const PlaybackSettings(),
                          const DesktopLyricsSettingsTab(),
                          _SettingsPlaceholder(title: tabTitles[4]),
                          const AdvancedSettings(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    List<String> _,
  ) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.tune_rounded,
                size: 24,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                Text(
                  l10n.settings,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: .w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  l10n.featureComingSoon, // Or something like "Manage your application preference"
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, List<String> tabTitles) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3,
            color: theme.colorScheme.primary,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
        labelStyle: const TextStyle(
          fontWeight: .w900,
          fontSize: 15,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: .w700,
          fontSize: 15,
        ),
        tabs: tabTitles.map((String title) => Tab(text: title)).toList(),
      ),
    );
  }
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 40,
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: .w900,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.featureComingSoon,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: .w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
