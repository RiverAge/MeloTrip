// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSession)
final userSessionProvider = UserSessionProvider._();

final class UserSessionProvider
    extends $AsyncNotifierProvider<UserSession, UserSessionSnapshot> {
  UserSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSessionHash();

  @$internal
  @override
  UserSession create() => UserSession();
}

String _$userSessionHash() => r'67a1df7f76ad733237a7dafbecb34a628a6a2074';

abstract class _$UserSession extends $AsyncNotifier<UserSessionSnapshot> {
  FutureOr<UserSessionSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<UserSessionSnapshot>, UserSessionSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserSessionSnapshot>, UserSessionSnapshot>,
              AsyncValue<UserSessionSnapshot>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(sessionAuth)
final sessionAuthProvider = SessionAuthProvider._();

final class SessionAuthProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthUser?>,
          AuthUser?,
          FutureOr<AuthUser?>
        >
    with $FutureModifier<AuthUser?>, $FutureProvider<AuthUser?> {
  SessionAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionAuthHash();

  @$internal
  @override
  $FutureProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthUser?> create(Ref ref) {
    return sessionAuth(ref);
  }
}

String _$sessionAuthHash() => r'96164798306cdce67f4299acdf5cee863d1d1b5c';

@ProviderFor(sessionConfig)
final sessionConfigProvider = SessionConfigProvider._();

final class SessionConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<Configuration?>,
          Configuration?,
          FutureOr<Configuration?>
        >
    with $FutureModifier<Configuration?>, $FutureProvider<Configuration?> {
  SessionConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionConfigHash();

  @$internal
  @override
  $FutureProviderElement<Configuration?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Configuration?> create(Ref ref) {
    return sessionConfig(ref);
  }
}

String _$sessionConfigHash() => r'dde223b39457458c73f24bbb22c201b887f88e33';
