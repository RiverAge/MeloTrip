import 'package:flutter/material.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_config.g.dart';

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  Future<ThemeMode?> build() async {
    final user = await User.instance;
    return user.themeMode;
  }

  Future<void> setMode(ThemeMode mode) async {
    final user = await User.instance;
    user.themeMode = mode;
    state = AsyncData(mode);
  }
}

@riverpod
class UserMaxBitRate extends _$UserMaxBitRate {
  @override
  Future<String?> build() async {
    final user = await User.instance;
    return user.maxRate;
  }

  Future<void> setRate(String rate) async {
    final user = await User.instance;
    user.maxRate = rate;
    state = AsyncData(rate);
  }
}

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Future<Locale?> build() async {
    final user = await User.instance;
    return user.locale;
  }

  Future<void> setLocale(Locale? locale) async {
    final user = await User.instance;
    user.locale = locale;
    state = AsyncData(locale);
  }
}
