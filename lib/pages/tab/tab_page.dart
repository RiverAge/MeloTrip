import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/tab/music_bar/parts/music_bar.dart';
import 'package:melo_trip/pages/home/home_page.dart';
import 'package:melo_trip/pages/settings/settings_page.dart';
import 'package:melo_trip/pages/ai_chat/ai_chat_page.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class TabPage extends ConsumerStatefulWidget {
  const TabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TabPage>
    with TickerProviderStateMixin {
  TabController? _controller;

  int _currentIndex = 0;

  @override
  void dispose() {
    _controller?.dispose();

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

  // int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uc = ref.watch(userConfigProvider);
    final aiApiConfiged = uc.valueOrNull?.aiApiUrl?.isNotEmpty ?? false;

    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.music_note),
        label: 'MeloTrip',
      ),
      if (aiApiConfiged)
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: AppLocalizations.of(context)!.aiChat,
        ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: AppLocalizations.of(context)!.settings,
      ),
    ];
    final tabViews = [
      const HomePage(),
      if (aiApiConfiged) AiChatPage(),
      const SettingsPage(),
    ];

    final currentLength = items.length;
    final controllerLength = _controller?.length;
    if (controllerLength == null || controllerLength != currentLength) {
      _currentIndex = 0;
      _setController(length: currentLength, initialIndex: _currentIndex);
    }

    return Scaffold(
      bottomSheet: _currentIndex == 1 && currentLength == 3
          ? null
          : const MusicBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _setTab,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: items,
      ),
      body: TabBarView(controller: _controller, children: tabViews),
    );
  }
}
