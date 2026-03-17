import 'package:flutter/material.dart';

enum AppThemeSeed { rose, ocean, emerald, amber, violet, teal, slate, coral }

extension AppThemeSeedX on AppThemeSeed {
  Color get color {
    return switch (this) {
      AppThemeSeed.rose => const Color(0xFFDB1D5D),
      AppThemeSeed.ocean => const Color(0xFF0B6FD3),
      AppThemeSeed.emerald => const Color(0xFF0C8A62),
      AppThemeSeed.amber => const Color(0xFFB96900),
      AppThemeSeed.violet => const Color(0xFF6A4CC2),
      AppThemeSeed.teal => const Color(0xFF007B7F),
      AppThemeSeed.slate => const Color(0xFF4E627A),
      AppThemeSeed.coral => const Color(0xFFC84B4B),
    };
  }
}
