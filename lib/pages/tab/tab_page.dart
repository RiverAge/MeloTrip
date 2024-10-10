import 'package:flutter/material.dart';
import 'package:melo_trip/pages/tab/music_bar/parts/music_bar.dart';
import 'package:melo_trip/pages/home/home_page.dart';
import 'package:melo_trip/pages/settings/settings_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() => _TablePageState();
}

class _TablePageState extends State<TabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  late int _currentIndex;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _currentIndex = _controller.index;
    _controller.animation?.addListener(_indexChangeListener);

    super.initState();
  }

  @override
  void dispose() {
    _controller.animation?.removeListener(_indexChangeListener);
    _controller.dispose();

    super.dispose();
  }

  _indexChangeListener() {
    if (_currentIndex != _controller.index) {
      setState(() {
        _currentIndex = _controller.index;
      });
    }
  }

  _setTab(int index) {
    _controller.animateTo(index);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomSheet: const MusicBar(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _setTab,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.music_note), label: 'MeloTrip'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置')
            ],
          ),
          body: TabBarView(
            controller: _controller,
            children: const [HomePage(), SettingsPage()],
          ),
        ),
      );
}
