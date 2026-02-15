import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_database/app_database.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';

part 'auth.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<AuthUser?> build() async {
    final db = await ref.read(appDatabaseProvider.future);
    return db.transaction<AuthUser?>((tnx) async {
      final rows = await tnx.query('current_user', orderBy: 'update_at DESC');
      if (rows.isEmpty) {
        return null;
      } else {
        return AuthUser.fromJson({
          'salt': rows.first['salt'],
          'token': rows.first['token'],
          'username': rows.first['username'],
          'host': rows.first['host'],
        });
      }
    });
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
        final db = await ref.read(appDatabaseProvider.future);
        await db.transaction((tnx) async {
          await tnx.insert('current_user', {
            'salt': auth.salt,
            'token': auth.token,
            'username': auth.username,
            'host': auth.host,
            'update_at': DateTime.now().millisecondsSinceEpoch,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        });
        ref.invalidate(currentUserProvider);
        ref.invalidate(userConfigProvider);
        return auth;
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}

@riverpod
Future<void> logout(Ref ref) async {
  final db = await ref.read(appDatabaseProvider.future);
  await db.transaction<void>((tnx) async {
    await tnx.delete('current_user', where: '1=1');
  });
  ref.invalidate(currentUserProvider);
  ref.invalidate(userConfigProvider);
}
