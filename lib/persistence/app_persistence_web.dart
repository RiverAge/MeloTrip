// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/persistence/app_persistence.dart';

class WebAppPersistence implements AppPersistence {
  static const String _currentUserKey = 'melotrip.current_user';
  static const String _userConfigPrefix = 'melotrip.user_config.';

  @override
  Future<AuthUser?> loadCurrentUser() async {
    final raw = html.window.localStorage[_currentUserKey];
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return AuthUser.fromJson(_decodeMap(raw));
  }

  @override
  Future<void> saveCurrentUser(AuthUser user) async {
    html.window.localStorage[_currentUserKey] = jsonEncode(user.toJson());
  }

  @override
  Future<void> clearCurrentUser() async {
    html.window.localStorage.remove(_currentUserKey);
  }

  @override
  Future<Configuration?> loadUserConfig(String username) async {
    final raw = html.window.localStorage[_userConfigKey(username)];
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return Configuration.fromJson(_decodeMap(raw));
  }

  @override
  Future<void> saveUserConfig(Configuration configuration) async {
    final username = configuration.username;
    if (username == null || username.isEmpty) {
      throw StateError('Configuration username is required.');
    }
    final data = configuration.toJson()
      ..['update_at'] = DateTime.now().millisecondsSinceEpoch;
    html.window.localStorage[_userConfigKey(username)] = jsonEncode(data);
  }

  @override
  Future<void> close() async {}

  String _userConfigKey(String username) => '$_userConfigPrefix$username';

  Map<String, dynamic> _decodeMap(String raw) {
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }
}
