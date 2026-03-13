import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/provider/persistence/persistence.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_config.g.dart';

class ValueUpdater<T> {
  final T value;
  const ValueUpdater(this.value);
}

@riverpod
class UserConfig extends _$UserConfig {
  @override
  Future<Configuration?> build() async {
    final persistence = await ref.read(appPersistenceProvider.future);
    final authUser = await ref.read(currentUserProvider.future);
    final username = authUser?.username;
    if (username == null || username.isEmpty) return null;

    final existing = await persistence.loadUserConfig(username);
    if (existing != null) {
      return existing;
    }

    final configuration = Configuration(
      username: username,
      updateAt: DateTime.now().millisecondsSinceEpoch,
    );
    await persistence.saveUserConfig(configuration);
    return configuration;
  }

  Future<void> setConfiguration({
    ValueUpdater<ThemeMode?>? theme,
    ValueUpdater<String?>? maxRate,
    ValueUpdater<PlaylistMode?>? playlistMode,
    ValueUpdater<Locale?>? locale,
    ValueUpdater<String?>? recentSearches,
    ValueUpdater<String>? recentSearch,
    ValueUpdater<String?>? desktopLyricsConfig,
  }) async {
    final persistence = await ref.read(appPersistenceProvider.future);
    final authUser = await ref.read(currentUserProvider.future);
    final username = authUser?.username;
    if (username == null || username.isEmpty) return;

    if (recentSearch != null) {
      final Configuration? configuration = state.asData?.value ?? await future;
      final List<String> searches = _parseRecentSearches(
        configuration?.recentSearches,
      );
      final String query = recentSearch.value.trim();
      if (query.isNotEmpty) {
        searches.remove(query);
        searches.insert(0, query);
        recentSearches = ValueUpdater(searches.take(20).join(','));
      }
    }

    final Configuration current =
        state.asData?.value ??
        await future ??
        Configuration(username: username);
    final Configuration updated = current.copyWith(
      username: username,
      maxRate: maxRate?.value ?? current.maxRate,
      playlistMode: playlistMode?.value ?? current.playlistMode,
      recentSearches: recentSearches?.value ?? current.recentSearches,
      desktopLyricsConfig:
          desktopLyricsConfig?.value ?? current.desktopLyricsConfig,
      theme: theme?.value ?? current.theme,
      locale: locale?.value ?? current.locale,
      updateAt: DateTime.now().millisecondsSinceEpoch,
    );

    await persistence.saveUserConfig(updated);
    ref.invalidateSelf();
  }

  List<String> _parseRecentSearches(String? value) {
    return (value ?? '')
        .split(',')
        .where((String item) => item.isNotEmpty)
        .toList();
  }
}

// @riverpod
// class AppThemeMode extends _$AppThemeMode {
//   @override
//   Future<ThemeMode?> build() async {
//     final user = await User.instance;
//     return user.themeMode;
//   }

// }

// @riverpod
// class UserMaxBitRate extends _$UserMaxBitRate {
//   @override
//   Future<String?> build() async {
//     final user = await User.instance;
//     return user.maxRate;
//   }

//   Future<void> setRate(String rate) async {
//     final user = await User.instance;
//     user.maxRate = rate;
//     state = AsyncData(rate);
//   }
// }

// @riverpod
// class AppLocale extends _$AppLocale {
//   @override
//   Future<Locale?> build() async {
//     final user = await User.instance;
//     return user.locale;
//   }

//   Future<void> setLocale(Locale? locale) async {
//     final user = await User.instance;
//     user.locale = locale;
//     state = AsyncData(locale);
//   }
// }
