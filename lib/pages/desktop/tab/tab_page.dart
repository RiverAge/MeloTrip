import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/desktop/player/full_player_page.dart';
import 'package:melo_trip/pages/desktop/tab/parts/search_command_palette.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';
import 'package:melo_trip/pages/desktop/library/songs_page.dart';
import 'package:melo_trip/pages/desktop/library/albums_page.dart';
import 'package:melo_trip/pages/desktop/library/artists_page.dart';
import 'package:melo_trip/pages/desktop/library/favorites_page.dart';
import 'package:melo_trip/pages/desktop/library/folders_page.dart';
import 'package:melo_trip/pages/desktop/library/genres_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';

part 'parts/sidebar.dart';
part 'parts/sidebar_search_button.dart';
part 'parts/nav_tile.dart';
part 'parts/playlist_tile.dart';
part 'parts/sidebar_server_card.dart';
part 'parts/player_bar.dart';
part 'parts/player_bar_left.dart';
part 'parts/player_bar_center.dart';
part 'parts/player_bar_actions.dart';
part 'parts/progress_bar.dart';
part 'parts/volume_bar.dart';
part 'parts/queue_sheet.dart';

class DesktopTabPage extends ConsumerStatefulWidget {
  const DesktopTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DesktopTabPageState();
}

class _DesktopTabPageState extends ConsumerState<DesktopTabPage> {
  static const _desktopBreakpoint = 1280.0;

  int _desktopIndex = 0;
  bool _showFullPlayer = false; // 控制详情页显示的局部状态
  final GlobalKey<NavigatorState> contentNavigatorKey =
      GlobalKey<NavigatorState>();

  void _setDesktopTab(int index) {
    if (_desktopIndex == index) {
      // 如果点击的是当前已选中的 Tab，则尝试将其内部导航退回到首页
      contentNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _desktopIndex = index;
    });

    // 使用局部导航器切换根页面，并清空该 Tab 之前的导航历史
    final routeName = _getRouteName(index);
    contentNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  String _getRouteName(int index) {
    switch (index) {
      case 0:
        return '/';
      case 1:
        return '/settings';
      case 2:
        return '/favorites';
      case 3:
        return '/albums';
      case 4:
        return '/songs';
      case 5:
        return '/artists';
      case 6:
        return '/genres';
      case 7:
        return '/folders';
      default:
        return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
        return _buildLargeScaffold(
          key: const ValueKey('desktop-layout'),
          l10n: l10n,
          isDesktop: isDesktop,
          currentIndex: _desktopIndex,
        );
      },
    );
  }

  Widget _buildLargeScaffold({
    required Key key,
    required AppLocalizations l10n,
    required bool isDesktop,
    required int currentIndex,
  }) {
    return Scaffold(
      key: key,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      _DesktopSidebar(
                        currentIndex: currentIndex,
                        onSelected: _setDesktopTab,
                        l10n: l10n,
                        compact: !isDesktop,
                      ),
                      VerticalDivider(
                        width: 1,
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: .35),
                      ),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh,
                                Theme.of(context).colorScheme.surface,
                              ],
                            ),
                          ),
                          child: Navigator(
                            key: contentNavigatorKey,
                            initialRoute: '/',
                            onGenerateRoute: (settings) {
                              Widget page;
                              switch (settings.name) {
                                case '/':
                                  page = const DesktopHomePage();
                                  break;
                                case '/settings':
                                  page = const DesktopSettingsPage();
                                  break;
                                case '/songs':
                                  page = const DesktopSongsPage();
                                  break;
                                case '/favorites':
                                  page = const DesktopFavoritesPage();
                                  break;
                                case '/genres':
                                  page = const DesktopGenresPage();
                                  break;
                                case '/albums':
                                  page = const DesktopAlbumsPage();
                                  break;
                                case '/artists':
                                  page = const DesktopArtistsPage();
                                  break;
                                case '/folders':
                                  page = const DesktopFoldersPage();
                                  break;
                                case '/playlist_detail':
                                  final id = settings.arguments;
                                  if (id is String && id.isNotEmpty) {
                                    page = DesktopPlaylistDetailPage(
                                      playlistId: id,
                                    );
                                  } else {
                                    page = const DesktopHomePage();
                                  }
                                  break;
                                default:
                                  page = const DesktopHomePage();
                              }
                              return PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        page,
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return child;
                                    },
                                settings: settings,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 全量播放器遮挡层
                  if (_showFullPlayer)
                    Positioned.fill(
                      child: DesktopFullPlayerPage(
                        onDismiss: () =>
                            setState(() => _showFullPlayer = false),
                      ),
                    ),
                ],
              ),
            ),
            _DesktopPlayerBar(
              onToggleFullPlayer: () =>
                  setState(() => _showFullPlayer = !_showFullPlayer),
            ),
          ],
        ),
      ),
    );
  }
}
