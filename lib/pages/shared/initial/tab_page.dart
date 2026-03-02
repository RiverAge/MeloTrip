import 'package:flutter/material.dart';
import 'package:melo_trip/pages/desktop/tab/tab_page.dart';
import 'package:melo_trip/pages/mobile/mobile_tab_page.dart';

class TabPage extends StatelessWidget {
  const TabPage({super.key});

  static const _tabletBreakpoint = 840.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= _tabletBreakpoint;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isTablet
              ? const DesktopTabPage(key: ValueKey('desktop-tab-page'))
              : const MobileTabPage(key: ValueKey('mobile-tab-page')),
        );
      },
    );
  }
}
