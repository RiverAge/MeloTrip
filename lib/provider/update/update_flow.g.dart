// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_flow.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUpdateService)
final appUpdateServiceProvider = AppUpdateServiceProvider._();

final class AppUpdateServiceProvider
    extends
        $FunctionalProvider<
          AppUpdateService,
          AppUpdateService,
          AppUpdateService
        >
    with $Provider<AppUpdateService> {
  AppUpdateServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateServiceHash();

  @$internal
  @override
  $ProviderElement<AppUpdateService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppUpdateService create(Ref ref) {
    return appUpdateService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateService>(value),
    );
  }
}

String _$appUpdateServiceHash() => r'757d1c4cd8962dead3103bcdfff67972424d36da';

@ProviderFor(UpdateFlowController)
final updateFlowControllerProvider = UpdateFlowControllerProvider._();

final class UpdateFlowControllerProvider
    extends $NotifierProvider<UpdateFlowController, UpdateFlowState> {
  UpdateFlowControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateFlowControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateFlowControllerHash();

  @$internal
  @override
  UpdateFlowController create() => UpdateFlowController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateFlowState>(value),
    );
  }
}

String _$updateFlowControllerHash() =>
    r'bd2fe21050f3aa58f467c6f492ce88c3dd66838f';

abstract class _$UpdateFlowController extends $Notifier<UpdateFlowState> {
  UpdateFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UpdateFlowState, UpdateFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UpdateFlowState, UpdateFlowState>,
              UpdateFlowState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
