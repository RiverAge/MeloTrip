import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/provider/persistence/persistence.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/repository/auth/auth_repository.dart';
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

String _generateSalt() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (_) => chars[Random().nextInt(chars.length)]).join();
}

String _generateToken(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  return md5.convert(bytes).toString();
}

@riverpod
Future<AuthUser?> login(
  Ref ref, {
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
  return auth;
}

@Riverpod(keepAlive: true)
Future<void> logout(Ref ref) async {
  final persistence = await ref.read(appPersistenceProvider.future);
  await persistence.clearCurrentUser();
  ref.invalidate(currentUserProvider);
  ref.invalidate(userConfigProvider);
}
