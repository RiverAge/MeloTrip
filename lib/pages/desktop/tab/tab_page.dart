import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' show AudioDevice;
import 'package:melo_trip/app_logic/restore/play_queue_restore.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/pages/desktop/library/albums_page.dart';
import 'package:melo_trip/pages/desktop/library/artists_page.dart';
import 'package:melo_trip/pages/desktop/library/favorites_page.dart';
import 'package:melo_trip/pages/desktop/library/folders_page.dart';
import 'package:melo_trip/pages/desktop/library/genres_page.dart';
import 'package:melo_trip/pages/desktop/library/songs_page.dart';
import 'package:melo_trip/pages/desktop/library/genre_detail_page.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/pages/desktop/player/full_player_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/desktop/tab/parts/search_command_palette.dart';
import 'package:melo_trip/pages/shared/player/play_queue_panel.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';

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

class _DesktopTabPageState extends ConsumerState<DesktopTabPage>
    with SingleTickerProviderStateMixin {
  static const double _desktopBreakpoint = 1280.0;

  final GlobalKey<NavigatorState> _contentNavigatorKey =
      GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get contentNavigatorKey => _contentNavigatorKey;

  int _desktopIndex = 0;
  String? _selectedPlaylistId;
  bool _showFullPlayer = false;

  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: DesktopMotionTokens.medium,
    );
    _slideAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DesktopMotionTokens.standardCurve,
      ),
    );

    unawaited(ensurePlayQueueRestored(ref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setDesktopTab(int index) {
    if (_desktopIndex == index && _selectedPlaylistId == null) return;
    final String routeName = _getRouteName(index);
    setState(() {
      _desktopIndex = index;
      _selectedPlaylistId = null;
    });
    _contentNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<Object?> route) => false,
    );
  }

  void _setPlaylistTab(String id) {
    if (_selectedPlaylistId == id) return;
    setState(() {
      _desktopIndex = -1; // Deselect library items
      _selectedPlaylistId = id;
    });
    _contentNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/playlist_detail',
      (Route<Object?> route) => false,
      arguments: id,
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

  Route<void> _buildContentRoute(RouteSettings settings) {
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
      case '/genre_detail':
        final arg = settings.arguments;
        if (arg is GenreEntity) {
          page = DesktopGenreDetailPage(genre: arg);
        } else {
          page = const DesktopHomePage();
        }
        break;
      case '/playlist_detail':
        final id = settings.arguments;
        if (id is String && id.isNotEmpty) {
          page = DesktopPlaylistDetailPage(playlistId: id);
        } else {
          page = const DesktopHomePage();
        }
        break;
      default:
        page = const DesktopHomePage();
    }

    return PageRouteBuilder<void>(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      settings: settings,
      pageBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => page,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isDesktop = constraints.maxWidth >= _desktopBreakpoint;
        return _buildLargeScaffold(
          key: const ValueKey<String>('desktop-layout'),
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
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _DesktopSidebar(
                            currentIndex: currentIndex,
                            selectedPlaylistId: _selectedPlaylistId,
                            onSelected: _setDesktopTab,
                            onPlaylistSelected: _setPlaylistTab,
                            l10n: l10n,
                            compact: !isDesktop,
                          ),
                          VerticalDivider(
                            width: 1,
                            color: Theme.of(context).colorScheme.outlineVariant
                                .withValues(alpha: 0.35),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHigh,
                                    Theme.of(context).colorScheme.surface,
                                  ],
                                ),
                              ),
                              child: Navigator(
                                key: _contentNavigatorKey,
                                initialRoute: '/',
                                onGenerateRoute: _buildContentRoute,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showFullPlayer)
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Positioned(
                              height: constraints.maxHeight,
                              left: 0,
                              right: 0,
                              top:
                                  constraints.maxHeight -
                                  constraints.maxHeight * _slideAnimation.value,
                              child: DesktopFullPlayerPage(
                                onDismiss: () async {
                                  await _controller.reverse();
                                  setState(() {
                                    _showFullPlayer = false;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            _DesktopPlayerBar(
              onToggleFullPlayer: () async {
                final current = _showFullPlayer;
                if (current) {
                  await _controller.reverse();
                  setState(() {
                    _showFullPlayer = false;
                  });
                } else {
                  _controller.forward();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _showFullPlayer = true;
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
