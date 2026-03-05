// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cachedFileSize)
final cachedFileSizeProvider = CachedFileSizeProvider._();

final class CachedFileSizeProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CachedFileSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedFileSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedFileSizeHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return cachedFileSize(ref);
  }
}

String _$cachedFileSizeHash() => r'408c46044aef5889a12c91800dc4cb6b66530019';
