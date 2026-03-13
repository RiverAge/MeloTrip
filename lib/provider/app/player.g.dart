// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppPlayerHandler)
final appPlayerHandlerProvider = AppPlayerHandlerProvider._();

final class AppPlayerHandlerProvider
    extends $AsyncNotifierProvider<AppPlayerHandler, AppPlayer?> {
  AppPlayerHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPlayerHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPlayerHandlerHash();

  @$internal
  @override
  AppPlayerHandler create() => AppPlayerHandler();
}

String _$appPlayerHandlerHash() => r'ef6c289d1c02f151097426b5409b9e734376c580';

abstract class _$AppPlayerHandler extends $AsyncNotifier<AppPlayer?> {
  FutureOr<AppPlayer?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppPlayer?>, AppPlayer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppPlayer?>, AppPlayer?>,
              AsyncValue<AppPlayer?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
