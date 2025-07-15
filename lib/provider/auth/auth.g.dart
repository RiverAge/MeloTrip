// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginHash() => r'fb426e959428c5089a3e3c086f8df530d37c0b5d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [login].
@ProviderFor(login)
const loginProvider = LoginFamily();

/// See also [login].
class LoginFamily extends Family<AsyncValue<AuthUser?>> {
  /// See also [login].
  const LoginFamily();

  /// See also [login].
  LoginProvider call({
    required String host,
    required String username,
    required String password,
  }) {
    return LoginProvider(host: host, username: username, password: password);
  }

  @override
  LoginProvider getProviderOverride(covariant LoginProvider provider) {
    return call(
      host: provider.host,
      username: provider.username,
      password: provider.password,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loginProvider';
}

/// See also [login].
class LoginProvider extends AutoDisposeFutureProvider<AuthUser?> {
  /// See also [login].
  LoginProvider({
    required String host,
    required String username,
    required String password,
  }) : this._internal(
         (ref) => login(
           ref as LoginRef,
           host: host,
           username: username,
           password: password,
         ),
         from: loginProvider,
         name: r'loginProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product') ? null : _$loginHash,
         dependencies: LoginFamily._dependencies,
         allTransitiveDependencies: LoginFamily._allTransitiveDependencies,
         host: host,
         username: username,
         password: password,
       );

  LoginProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.host,
    required this.username,
    required this.password,
  }) : super.internal();

  final String host;
  final String username;
  final String password;

  @override
  Override overrideWith(
    FutureOr<AuthUser?> Function(LoginRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoginProvider._internal(
        (ref) => create(ref as LoginRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        host: host,
        username: username,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AuthUser?> createElement() {
    return _LoginProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginProvider &&
        other.host == host &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);
    hash = _SystemHash.combine(hash, username.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoginRef on AutoDisposeFutureProviderRef<AuthUser?> {
  /// The parameter `host` of this provider.
  String get host;

  /// The parameter `username` of this provider.
  String get username;

  /// The parameter `password` of this provider.
  String get password;
}

class _LoginProviderElement extends AutoDisposeFutureProviderElement<AuthUser?>
    with LoginRef {
  _LoginProviderElement(super.provider);

  @override
  String get host => (origin as LoginProvider).host;
  @override
  String get username => (origin as LoginProvider).username;
  @override
  String get password => (origin as LoginProvider).password;
}

String _$logoutHash() => r'572745a7e4d85a7f18f536b25647056bbdb491d9';

/// See also [logout].
@ProviderFor(logout)
final logoutProvider = AutoDisposeFutureProvider<void>.internal(
  logout,
  name: r'logoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutRef = AutoDisposeFutureProviderRef<void>;
String _$currentUserHash() => r'dc6c979290818d9176cf0f37fbf81a612bd585f0';

/// See also [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeAsyncNotifierProvider<CurrentUser, AuthUser?>.internal(
      CurrentUser.new,
      name: r'currentUserProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentUserHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentUser = AutoDisposeAsyncNotifier<AuthUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
