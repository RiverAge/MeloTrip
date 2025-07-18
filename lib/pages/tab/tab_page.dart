import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
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

  void _indexChangeListener() {
    if (_currentIndex != _controller.index) {
      setState(() {
        _currentIndex = _controller.index;
      });
    }
  }

  void _setTab(int index) {
    _controller.animateTo(index);
  }

  // int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //  LayoutBuilder(
    // builder: (context, dimens) {
    // if (dimens.maxWidth >= 600) {
    //   return Scaffold(
    //     body: Column(
    //       children: [
    //         Expanded(
    //           child: Row(
    //             children: [
    //               NavigationRail(
    //                 leading: Text(
    //                   'MeloTrip',
    //                   style: TextStyle(fontWeight: FontWeight.bold),
    //                 ),
    //                 elevation: 3.0,
    //                 extended: dimens.maxWidth >= 800,
    //                 minExtendedWidth: 180,
    //                 destinations: const [
    //                   NavigationRailDestination(
    //                     icon: Icon(Icons.home),
    //                     selectedIcon: Icon(Icons.home_filled),
    //                     label: Text('Home'),
    //                   ),
    //                   NavigationRailDestination(
    //                     icon: Icon(Icons.star),
    //                     selectedIcon: Icon(Icons.star_border),
    //                     label: Text('Favorites'),
    //                   ),
    //                   NavigationRailDestination(
    //                     icon: Icon(Icons.settings),
    //                     selectedIcon: Icon(Icons.settings),
    //                     label: Text('Settings'),
    //                   ),
    //                 ],
    //                 selectedIndex: _selectedIndex,
    //                 onDestinationSelected: (int index) {
    //                   setState(() {
    //                     _selectedIndex = index;
    //                   });
    //                 },
    //               ),
    //               // Expanded(
    //               //   child: Container(
    //               //     decoration: BoxDecoration(
    //               //       border: Border.all(width: 0, color: Colors.yellow),
    //               //     ),
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //         MusicBar(),
    //       ],
    //     ),
    //   );
    // }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomSheet: const MusicBar(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _setTab,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'MeloTrip',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: const [HomePage(), SettingsPage()],
        ),
      ),
    );
  }
}
