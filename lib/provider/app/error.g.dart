// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppErrorNotifier)
final appErrorProvider = AppErrorNotifierProvider._();

final class AppErrorNotifierProvider
    extends $NotifierProvider<AppErrorNotifier, AppErrorEvent?> {
  AppErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appErrorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appErrorNotifierHash();

  @$internal
  @override
  AppErrorNotifier create() => AppErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppErrorEvent? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppErrorEvent?>(value),
    );
  }
}

String _$appErrorNotifierHash() => r'40d5500333ce95eb33a1b568ae7159132714862f';

abstract class _$AppErrorNotifier extends $Notifier<AppErrorEvent?> {
  AppErrorEvent? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppErrorEvent?, AppErrorEvent?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppErrorEvent?, AppErrorEvent?>,
              AppErrorEvent?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
