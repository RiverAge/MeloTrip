// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_error.dart';

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

String _$appErrorNotifierHash() => r'c09be0153e8b505683ee7859441a17303895853d';

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
