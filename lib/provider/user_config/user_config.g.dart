// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserConfig)
final userConfigProvider = UserConfigProvider._();

final class UserConfigProvider
    extends $AsyncNotifierProvider<UserConfig, Configuration?> {
  UserConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userConfigHash();

  @$internal
  @override
  UserConfig create() => UserConfig();
}

String _$userConfigHash() => r'f440435333f342b84db0e7882afffd620aa21f74';

abstract class _$UserConfig extends $AsyncNotifier<Configuration?> {
  FutureOr<Configuration?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Configuration?>, Configuration?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Configuration?>, Configuration?>,
              AsyncValue<Configuration?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
