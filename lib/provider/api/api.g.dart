// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Api)
final apiProvider = ApiProvider._();

final class ApiProvider extends $AsyncNotifierProvider<Api, Dio> {
  ApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiHash();

  @$internal
  @override
  Api create() => Api();
}

String _$apiHash() => r'7562e6ee6133626d66496ff4115c238d2315a939';

abstract class _$Api extends $AsyncNotifier<Dio> {
  FutureOr<Dio> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Dio>, Dio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Dio>, Dio>,
              AsyncValue<Dio>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
