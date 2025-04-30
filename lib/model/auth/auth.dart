import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
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
