import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_page.dart';
import 'package:melo_trip/pages/mobile/favorite/favorite_page.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/pages/mobile/settings/app_theme_page.dart';
import 'package:melo_trip/pages/mobile/settings/language_page.dart';
import 'package:melo_trip/pages/mobile/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

class DesktopSettingsPage extends ConsumerWidget {
  const DesktopSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(l10n.settings),
          surfaceTintColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000 ? 2 : 1;
                final tiles = _buildTiles(context, l10n);
                return GridView.builder(
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
