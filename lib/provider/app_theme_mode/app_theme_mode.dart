import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_mode.g.dart';

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final themoModeStr = prefs.getString('__tm__');
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == '$themoModeStr',
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('__tm__', mode.toString());
    state = AsyncData(mode);
  }
}
