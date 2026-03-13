import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/restore/play_queue_restore.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/home/home_page.dart';
import 'package:melo_trip/pages/mobile/settings/settings_page.dart';
import 'package:melo_trip/pages/mobile/music_bar/parts/music_bar.dart';
import 'package:melo_trip/provider/route/route_observer.dart';

class MobileTabPage extends ConsumerStatefulWidget {
  const MobileTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileTabPageState();
}

class _MobileTabPageState extends ConsumerState<MobileTabPage> with RouteAware {
  int _currentIndex = 0;
  bool _visible = true;
  RouteObserver<PageRoute<dynamic>>? _routeObserver;
  PageRoute<dynamic>? _subscribedRoute;

  @override
  void initState() {
    super.initState();
    unawaited(ensurePlayQueueRestored(ref));
  }

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

  void _setTab(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.music_note),
        label: 'MeloTrip',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];
    final tabViews = [const HomePage(), const SettingsPage()];

    return Scaffold(
      bottomSheet: !_visible ? null : const MusicBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _setTab,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: items,
      ),
      body: IndexedStack(index: _currentIndex, children: tabViews),
    );
  }
}
