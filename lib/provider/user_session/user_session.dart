import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';
import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:melo_trip/provider/persistence/persistence.dart';
import 'package:melo_trip/provider/user_session/value_updater.dart';
import 'package:melo_trip/repository/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:melo_trip/provider/user_session/value_updater.dart';

part 'user_session.g.dart';

class UserSessionSnapshot {
  const UserSessionSnapshot({required this.auth, required this.config});

  final AuthUser? auth;
  final Configuration? config;
}

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  Future<UserSessionSnapshot> build() async {
    final persistence = await ref.read(appPersistenceProvider.future);
    final auth = await persistence.loadCurrentUser();
    final username = auth?.username;
    if (username == null || username.isEmpty) {
      return const UserSessionSnapshot(auth: null, config: null);
    }

    final config = await _loadOrCreateConfig(
      username: username,
      persistence: persistence,
    );
    return UserSessionSnapshot(auth: auth, config: config);
  }

  Future<AuthUser?> login({
    required String host,
    required String username,
    required String password,
  }) async {
    final persistence = await ref.read(appPersistenceProvider.future);
    final repository = ref.read(authRepositoryProvider);
    final salt = _generateSalt();
    final token = _generateToken(password, salt);
    final pingResult = await repository.tryPing(
      host: host,
      username: username,
      token: token,
      salt: salt,
    );
    if (pingResult.isErr) {
      throw Exception(pingResult.error?.message);
    }

    final auth = AuthUser.fromJson({
      'salt': salt,
      'token': token,
      'username': username,
      'host': host,
    });
    await persistence.saveCurrentUser(auth);
    final config = await _loadOrCreateConfig(
      username: username,
      persistence: persistence,
    );
    if (ref.mounted) {
      state = AsyncData(UserSessionSnapshot(auth: auth, config: config));
    }
    return auth;
  }

  Future<void> logout() async {
    final persistence = await ref.read(appPersistenceProvider.future);
    await persistence.clearCurrentUser();
    if (!ref.mounted) {
      return;
    }
    state = const AsyncData(UserSessionSnapshot(auth: null, config: null));
  }

  Future<void> setConfiguration({
    ValueUpdater<ThemeMode?>? theme,
    ValueUpdater<AppThemeSeed?>? themeSeed,
    ValueUpdater<String?>? maxRate,
    ValueUpdater<PlaylistMode?>? playlistMode,
    ValueUpdater<bool?>? shuffle,
    ValueUpdater<Locale?>? locale,
    ValueUpdater<String?>? recentSearches,
    ValueUpdater<String>? recentSearch,
    ValueUpdater<String?>? desktopLyricsConfig,
  }) async {
    final persistence = await ref.read(appPersistenceProvider.future);
    final session = state.asData?.value ?? await future;
    final username = session.auth?.username;
    if (username == null || username.isEmpty) {
      return;
    }

    final current = session.config ?? Configuration(username: username);
    final resolvedSearches = _resolveRecentSearches(
      current: current.recentSearches,
      recentSearches: recentSearches?.value,
      recentSearch: recentSearch?.value,
    );
    final updated = current.copyWith(
      username: username,
      maxRate: maxRate?.value ?? current.maxRate,
      playlistMode: playlistMode?.value ?? current.playlistMode,
      shuffle: shuffle?.value ?? current.shuffle,
      recentSearches: resolvedSearches,
      desktopLyricsConfig: desktopLyricsConfig?.value ?? current.desktopLyricsConfig,
      theme: theme?.value ?? current.theme,
      themeSeed: themeSeed?.value ?? current.themeSeed,
      locale: locale?.value ?? current.locale,
      updateAt: DateTime.now().millisecondsSinceEpoch,
    );
    await persistence.saveUserConfig(updated);
    if (ref.mounted) {
      state = AsyncData(UserSessionSnapshot(auth: session.auth, config: updated));
    }
  }

  Future<Configuration> _loadOrCreateConfig({
    required String username,
    required AppPersistence persistence,
  }) async {
    final existing = await persistence.loadUserConfig(username);
    if (existing != null) {
      return existing;
    }
    final config = Configuration(
      username: username,
      maxRate: '32',
      playlistMode: .none,
      shuffle: false,
      themeSeed: AppThemeSeed.rose,
      updateAt: DateTime.now().millisecondsSinceEpoch,
    );
    await persistence.saveUserConfig(config);
    return config;
  }

  String? _resolveRecentSearches({
    required String? current,
    required String? recentSearches,
    required String? recentSearch,
  }) {
    if (recentSearch != null) {
      final searches = (current ?? '')
          .split(',')
          .where((item) => item.isNotEmpty)
          .toList();
      final query = recentSearch.trim();
      if (query.isNotEmpty) {
        searches.remove(query);
        searches.insert(0, query);
        return searches.take(20).join(',');
      }
      return current;
    }
    return recentSearches ?? current;
  }
}

@riverpod
Future<AuthUser?> sessionAuth(Ref ref) async {
  final session = await ref.watch(userSessionProvider.future);
  return session.auth;
}

@riverpod
Future<Configuration?> sessionConfig(Ref ref) async {
  final session = await ref.watch(userSessionProvider.future);
  return session.config;
}

String _generateSalt() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (_) => chars[Random().nextInt(chars.length)]).join();
}

String _generateToken(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  return md5.convert(bytes).toString();
}
