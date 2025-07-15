import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/provider/app_database/app_database.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'user_config.g.dart';

class ValueUpdater<T> {
  final T value;
  const ValueUpdater(this.value);
}

@riverpod
class UserConfig extends _$UserConfig {
  @override
  Future<Configuration?> build() async {
    final db = await ref.read(appDatabaseProvider.future);
    final authUser = await ref.read(currentUserProvider.future);
    if (authUser?.id == null) return null;

    return db.transaction((tnx) async {
      final countResult = await tnx.query(
        'user_config',
        columns: ['count(*) as count'],
        where: 'user_id = ?',
        whereArgs: [authUser?.id],
      );
      final int count = Sqflite.firstIntValue(countResult) ?? 0;
      if (count == 0) {
        await tnx.insert('user_config', {
          'user_id': authUser?.id,
          'update_at': DateTime.now().millisecondsSinceEpoch,
        });
      }

      final rows = await tnx.query(
        'user_config',
        where: 'user_id = ?',
        whereArgs: [authUser?.id],
      );

      if (rows.isNotEmpty) {
        return Configuration.fromJson(rows.first);
      } else {
        return null;
      }
    });
  }

  Future<void> setConfiguration({
    ValueUpdater<ThemeMode?>? theme,
    ValueUpdater<String?>? maxRate,
    ValueUpdater<PlaylistMode?>? playlistMode,
    ValueUpdater<Locale?>? locale,
    ValueUpdater<String?>? recentSearches,
  }) async {
    final db = await ref.read(appDatabaseProvider.future);
    final authUser = await ref.read(currentUserProvider.future);
    if (authUser?.id == null) return;

    Map<String, Object?> values = {};
    if (maxRate != null) {
      values['max_rate'] = maxRate.value;
    }
    if (locale != null) {
      values['locale'] = locale.value;
    }
    if (playlistMode != null) {
      values['playlist_mode'] = playlistMode.value?.name;
    }
    if (theme != null) {
      values['theme'] = theme.value?.name;
    }
    if (recentSearches != null) {
      values['recent_searches'] = recentSearches.value;
    }

    if (values.isEmpty) return;
    values['update_at'] = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((tnx) async {
      await tnx.update(
        'user_config',
        values,
        where: 'user_id = ?',
        whereArgs: [authUser?.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    ref.invalidateSelf();
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
