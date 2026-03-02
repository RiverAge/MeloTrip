import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/pages/desktop/search/search_page.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/route/route_observer.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/sidebar.dart';
part 'parts/window_bar.dart';
part 'parts/player_bar.dart';

class DesktopTabPage extends ConsumerStatefulWidget {
  const DesktopTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DesktopTabPageState();
}

class _DesktopTabPageState extends ConsumerState<DesktopTabPage>
    with RouteAware {
  static const _desktopBreakpoint = 1280.0;

  int _desktopIndex = 0;
  bool _visible = true;
  RouteObserver<PageRoute<dynamic>>? _routeObserver;
  PageRoute<dynamic>? _subscribedRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final pageRoute = route is PageRoute<dynamic> ? route : null;
    if (pageRoute == null) return;

    final observer = ref.read(routeObserverProvider);
    final shouldResubscribe =
        _routeObserver != observer || _subscribedRoute != pageRoute;

    if (shouldResubscribe) {
      if (_routeObserver != null && _subscribedRoute != null) {
        _routeObserver?.unsubscribe(this);
      }
      _routeObserver = observer;
      _subscribedRoute = pageRoute;
      _routeObserver?.subscribe(this, pageRoute);
    }
  }

  @override
  void didPushNext() {
    if (_visible) {
      setState(() {
        _visible = false;
      });
    }
  }

  @override
  void didPopNext() {
    if (!_visible) {
      setState(() {
        _visible = true;
      });
    }
  }

  @override
  void dispose() {
    if (_routeObserver != null && _subscribedRoute != null) {
      _routeObserver?.unsubscribe(this);
    }
    super.dispose();
  }

  void _setDesktopTab(int index) {
    if (_desktopIndex == index) return;
    setState(() {
      _desktopIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final desktopTabViews = [
      const DesktopHomePage(),
      const DesktopSettingsPage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
        return _buildLargeScaffold(
          key: const ValueKey('desktop-layout'),
          l10n: l10n,
          tabViews: desktopTabViews,
          isDesktop: isDesktop,
          currentIndex: _desktopIndex,
        );
      },
    );
  }

  Widget _buildLargeScaffold({
    required Key key,
    required AppLocalizations l10n,
    required List<Widget> tabViews,
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
            const _DesktopWindowBar(),
            Expanded(
              child: Row(
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
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                            Theme.of(context).colorScheme.surface,
                          ],
                        ),
                      ),
                      child: IndexedStack(
                        index: currentIndex,
                        children: tabViews,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_visible) const _DesktopPlayerBar(),
          ],
        ),
      ),
    );
  }
}
