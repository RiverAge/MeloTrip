import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/persistence/persistence.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<AuthUser?> build() async {
    final persistence = await ref.read(appPersistenceProvider.future);
    return persistence.loadCurrentUser();
  }
}

/// 生成随机盐 (Salt)
String _generateSalt() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
    10,
    (index) => chars[Random().nextInt(chars.length)],
  ).join();
}

/// 生成 Token: md5(password + salt)
String _generateToken(String password, String salt) {
  var bytes = utf8.encode(password + salt); // 将 密码+盐 转为字节
  return md5.convert(bytes).toString(); // 计算 MD5 并转为十六进制字符串
}

@riverpod
Future<AuthUser?> login(
  Ref ref, {
  required String host,
  required String username,
  required String password,
}) async {
  final api = await ref.read(apiProvider.future);
  final persistence = await ref.read(appPersistenceProvider.future);

  try {
    final salt = _generateSalt();
    final token = _generateToken(password, salt);
    final res = await api.get<Map<String, dynamic>>(
      '$host/rest/ping',
      queryParameters: {
        'u': username,
        't': token, // 假设 token 是这样传递
        's': salt, // 假设 salt 是这样传递
        '_': DateTime.now().toIso8601String(),
        'v': '1.16.1',
        'c': 'melo_trip',
        'f': 'json',
      },
    );

    final data = res.data;
    if (data != null) {
      final subsonicResponse = SubsonicResponse.fromJson(data);
      if (subsonicResponse.subsonicResponse?.status == 'ok') {
        final auth = AuthUser.fromJson({
          'salt': salt,
          'token': token,
          'username': username,
          'host': host,
        });
        await persistence.saveCurrentUser(auth);
        return auth;
      }

      final errorMsg = subsonicResponse.subsonicResponse?.error?.message;
      throw Exception(errorMsg ?? 'Login failed');
    }

    throw Exception('Login failed');
  } catch (e, stackTrace) {
    debugPrint('Login failed: $e');
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }
}

@riverpod
Future<void> logout(Ref ref) async {
  final persistence = await ref.read(appPersistenceProvider.future);
  await persistence.clearCurrentUser();
  ref.invalidate(currentUserProvider);
  ref.invalidate(userConfigProvider);
}
