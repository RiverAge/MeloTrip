import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';

part 'parts/demo_page_state.dart';
part 'parts/demo_page_primary_sections.dart';
part 'parts/demo_page_secondary_sections.dart';
part 'parts/demo_page_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4A78F0),
        useMaterial3: true,
      ),
      home: const _DesktopLyricsDemoPage(),
    );
  }
}

class _DesktopLyricsDemoPage extends StatefulWidget {
  const _DesktopLyricsDemoPage();

  @override
  State<_DesktopLyricsDemoPage> createState() => _DesktopLyricsDemoPageState();
}
