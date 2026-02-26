import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/tab/music_bar/parts/music_bar.dart';
import 'package:melo_trip/pages/home/home_page.dart';
import 'package:melo_trip/pages/settings/settings_page.dart';
import 'package:melo_trip/provider/route/route_observer.dart';

class TabPage extends ConsumerStatefulWidget {
  const TabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TabPage>
    with TickerProviderStateMixin, RouteAware {
  TabController? _controller;

  int _currentIndex = 0;
  bool _visible = true;
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void dispose() {
    _controller?.dispose();
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  void _setController({required int length, int initialIndex = 0}) {
    _controller?.dispose();
    _controller = TabController(
      length: length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _controller?.addListener(_indexChangeListener);
  }

  void _indexChangeListener() {
    final controllerIndex = _controller?.index;
    if (controllerIndex != null && _currentIndex != controllerIndex) {
      setState(() {
        _currentIndex = controllerIndex;
      });
    }
  }

  void _setTab(int index) {
    _controller?.animateTo(index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      // 通过 ref.read 获取同一个实例进行订阅
      _routeObserver = ref.read(routeObserverProvider);
      _routeObserver?.subscribe(this, route);
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

  // 当上面的页面被弹出，当前页面重新显示（Pop 回来了）
  @override
  void didPopNext() {
    if (!_visible) {
      setState(() {
        _visible = true;
      });
    }
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
    final tabViews = [
      const HomePage(),
      const SettingsPage(),
    ];

    final currentLength = items.length;
    final controllerLength = _controller?.length;
    if (controllerLength == null || controllerLength != currentLength) {
      _currentIndex = 0;
      _setController(length: currentLength, initialIndex: _currentIndex);
    }

    return Scaffold(
      bottomSheet: !_visible ? null : const MusicBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _setTab,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: items,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: tabViews,
      ),
    );
  }
}
