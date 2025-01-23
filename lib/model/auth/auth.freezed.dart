// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return _Auth.fromJson(json);
}

/// @nodoc
mixin _$Auth {
  String? get id => throw _privateConstructorUsedError;
  bool? get isAdmin => throw _privateConstructorUsedError;
  String? get lastFmApiKey => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get subsonicSalt => throw _privateConstructorUsedError;
  String? get subsonicToken => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;

  /// Serializes this Auth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthCopyWith<Auth> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCopyWith<$Res> {
  factory $AuthCopyWith(Auth value, $Res Function(Auth) then) =
      _$AuthCopyWithImpl<$Res, Auth>;
  @useResult
  $Res call(
      {String? id,
      bool? isAdmin,
      String? lastFmApiKey,
      String? name,
      String? subsonicSalt,
      String? subsonicToken,
      String? token,
      String? username,
      String? host});
}

/// @nodoc
class _$AuthCopyWithImpl<$Res, $Val extends Auth>
    implements $AuthCopyWith<$Res> {
  _$AuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isAdmin = freezed,
    Object? lastFmApiKey = freezed,
    Object? name = freezed,
    Object? subsonicSalt = freezed,
    Object? subsonicToken = freezed,
    Object? token = freezed,
    Object? username = freezed,
    Object? host = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdmin: freezed == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastFmApiKey: freezed == lastFmApiKey
          ? _value.lastFmApiKey
          : lastFmApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      subsonicSalt: freezed == subsonicSalt
          ? _value.subsonicSalt
          : subsonicSalt // ignore: cast_nullable_to_non_nullable
              as String?,
      subsonicToken: freezed == subsonicToken
          ? _value.subsonicToken
          : subsonicToken // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthImplCopyWith<$Res> implements $AuthCopyWith<$Res> {
  factory _$$AuthImplCopyWith(
          _$AuthImpl value, $Res Function(_$AuthImpl) then) =
      __$$AuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      bool? isAdmin,
      String? lastFmApiKey,
      String? name,
      String? subsonicSalt,
      String? subsonicToken,
      String? token,
      String? username,
      String? host});
}

/// @nodoc
class __$$AuthImplCopyWithImpl<$Res>
    extends _$AuthCopyWithImpl<$Res, _$AuthImpl>
    implements _$$AuthImplCopyWith<$Res> {
  __$$AuthImplCopyWithImpl(_$AuthImpl _value, $Res Function(_$AuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isAdmin = freezed,
    Object? lastFmApiKey = freezed,
    Object? name = freezed,
    Object? subsonicSalt = freezed,
    Object? subsonicToken = freezed,
    Object? token = freezed,
    Object? username = freezed,
    Object? host = freezed,
  }) {
    return _then(_$AuthImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isAdmin: freezed == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastFmApiKey: freezed == lastFmApiKey
          ? _value.lastFmApiKey
          : lastFmApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      subsonicSalt: freezed == subsonicSalt
          ? _value.subsonicSalt
          : subsonicSalt // ignore: cast_nullable_to_non_nullable
              as String?,
      subsonicToken: freezed == subsonicToken
          ? _value.subsonicToken
          : subsonicToken // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthImpl implements _Auth {
  const _$AuthImpl(
      {this.id,
      this.isAdmin,
      this.lastFmApiKey,
      this.name,
      this.subsonicSalt,
      this.subsonicToken,
      this.token,
      this.username,
      this.host});

  factory _$AuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthImplFromJson(json);

  @override
  final String? id;
  @override
  final bool? isAdmin;
  @override
  final String? lastFmApiKey;
  @override
  final String? name;
  @override
  final String? subsonicSalt;
  @override
  final String? subsonicToken;
  @override
  final String? token;
  @override
  final String? username;
  @override
  final String? host;

  @override
  String toString() {
    return 'Auth(id: $id, isAdmin: $isAdmin, lastFmApiKey: $lastFmApiKey, name: $name, subsonicSalt: $subsonicSalt, subsonicToken: $subsonicToken, token: $token, username: $username, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.lastFmApiKey, lastFmApiKey) ||
                other.lastFmApiKey == lastFmApiKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subsonicSalt, subsonicSalt) ||
                other.subsonicSalt == subsonicSalt) &&
            (identical(other.subsonicToken, subsonicToken) ||
                other.subsonicToken == subsonicToken) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.host, host) || other.host == host));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, isAdmin, lastFmApiKey, name,
      subsonicSalt, subsonicToken, token, username, host);

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      __$$AuthImplCopyWithImpl<_$AuthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthImplToJson(
      this,
    );
  }
}

abstract class _Auth implements Auth {
  const factory _Auth(
      {final String? id,
      final bool? isAdmin,
      final String? lastFmApiKey,
      final String? name,
      final String? subsonicSalt,
      final String? subsonicToken,
      final String? token,
      final String? username,
      final String? host}) = _$AuthImpl;

  factory _Auth.fromJson(Map<String, dynamic> json) = _$AuthImpl.fromJson;

  @override
  String? get id;
  @override
  bool? get isAdmin;
  @override
  String? get lastFmApiKey;
  @override
  String? get name;
  @override
  String? get subsonicSalt;
  @override
  String? get subsonicToken;
  @override
  String? get token;
  @override
  String? get username;
  @override
  String? get host;

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
