// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPersistence)
final appPersistenceProvider = AppPersistenceProvider._();

final class AppPersistenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppPersistence>,
          AppPersistence,
          FutureOr<AppPersistence>
        >
    with $FutureModifier<AppPersistence>, $FutureProvider<AppPersistence> {
  AppPersistenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPersistenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPersistenceHash();

  @$internal
  @override
  $FutureProviderElement<AppPersistence> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppPersistence> create(Ref ref) {
    return appPersistence(ref);
  }
}

String _$appPersistenceHash() => r'577a14da4309b459e61cbb912e93226794a59c4f';
