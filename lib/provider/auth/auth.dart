import 'package:melo_trip/model/auth_user/auth_user.dart';
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
          'id': rows.first['id'],
          'isAdmin': rows.first['is_admin'] == '1',
          'name': rows.first['name'],
          'subsonicSalt': rows.first['subsonic_salt'],
          'subsonicToken': rows.first['subsonic_token'],
          'token': rows.first['token'],
          'username': rows.first['username'],
          'host': rows.first['host'],
        });
      }
    });
  }
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
    final res = await api.post<Map<String, dynamic>>(
      '$host/auth/login',
      data: {'username': username, 'password': password},
    );

    final data = res.data;
    if (data != null) {
      final auth = AuthUser.fromJson({...data, 'host': host});
      final db = await ref.read(appDatabaseProvider.future);
      await db.transaction((tnx) async {
        await tnx.insert('current_user', {
          'id': auth.id,
          'is_admin': auth.isAdmin == true ? '1' : '0',
          'name': auth.name,
          'subsonic_salt': auth.subsonicSalt,
          'subsonic_token': auth.subsonicToken,
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
