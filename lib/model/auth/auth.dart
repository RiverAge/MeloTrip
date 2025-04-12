import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
// 可选的：因为 Person 类是可序列化的，所以我们必须添加这一行。
// 但是如果 Person 不是可序列化的，我们可以跳过它。
part 'auth.g.dart';

@freezed
abstract class Auth with _$Auth {
  const factory Auth({
    String? id,
    bool? isAdmin,
    String? lastFmApiKey,
    String? name,
    String? subsonicSalt,
    String? subsonicToken,
    String? token,
    String? username,
    String? host,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}
