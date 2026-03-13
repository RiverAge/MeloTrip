import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/general_settings.dart';
import 'package:melo_trip/pages/desktop/settings/parts/lyrics_settings.dart';

class DesktopSettingsPage extends ConsumerStatefulWidget {
  const DesktopSettingsPage({super.key});

  @override
  ConsumerState<DesktopSettingsPage> createState() =>
      _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends ConsumerState<DesktopSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> _tabTitles(AppLocalizations l10n) => <String>[
    l10n.settingsTabGeneral,
    l10n.settingsTabPlayback,
    l10n.settingsTabLyrics,
    l10n.settingsTabHotkeys,
    l10n.settingsTabAdvanced,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final List<String> tabTitles = _tabTitles(l10n);

    return Scaffold(
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
                        controller: _tabController,
                        children: <Widget>[
                          const GeneralSettings(),
                          _SettingsPlaceholder(title: tabTitles[1]),
                          const DesktopLyricsSettingsTab(),
                          _SettingsPlaceholder(title: tabTitles[3]),
                          _SettingsPlaceholder(title: tabTitles[4]),
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
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    List<String> _,
  ) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  l10n.settings,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: .w900,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, List<String> tabTitles) {
    final ThemeData theme = Theme.of(context);
    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return theme.colorScheme.primary.withValues(alpha: 0.16);
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return theme.colorScheme.primary.withValues(alpha: 0.09);
          }
          return Colors.transparent;
        });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.38),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            overlayColor: overlayColor,
            splashBorderRadius: BorderRadius.circular(16),
            labelColor: theme.colorScheme.onPrimaryContainer,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.78),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            labelStyle: const TextStyle(
              fontWeight: .w800,
              fontSize: 13,
            ),
            tabs: tabTitles
                .map(
                  (String title) => Tab(
                    height: 42,
                    child: SizedBox(
                      height: 42,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(title),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: .min,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Icon(
                    Icons.construction_rounded,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: .w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.featureComingSoon,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
