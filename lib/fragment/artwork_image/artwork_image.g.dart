// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork_image.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$artworkUrlHash() => r'a8546119731fa0434ac1d33d8cefba9912dd0066';

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

/// See also [artworkUrl].
@ProviderFor(artworkUrl)
const artworkUrlProvider = ArtworkUrlFamily();

/// See also [artworkUrl].
class ArtworkUrlFamily extends Family<AsyncValue<String>> {
  /// See also [artworkUrl].
  const ArtworkUrlFamily();

  /// See also [artworkUrl].
  ArtworkUrlProvider call(String id) {
    return ArtworkUrlProvider(id);
  }

  @override
  ArtworkUrlProvider getProviderOverride(
    covariant ArtworkUrlProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'artworkUrlProvider';
}

/// See also [artworkUrl].
class ArtworkUrlProvider extends AutoDisposeFutureProvider<String> {
  /// See also [artworkUrl].
  ArtworkUrlProvider(String id)
    : this._internal(
        (ref) => artworkUrl(ref as ArtworkUrlRef, id),
        from: artworkUrlProvider,
        name: r'artworkUrlProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$artworkUrlHash,
        dependencies: ArtworkUrlFamily._dependencies,
        allTransitiveDependencies: ArtworkUrlFamily._allTransitiveDependencies,
        id: id,
      );

  ArtworkUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<String> Function(ArtworkUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArtworkUrlProvider._internal(
        (ref) => create(ref as ArtworkUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _ArtworkUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtworkUrlProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArtworkUrlRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ArtworkUrlProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with ArtworkUrlRef {
  _ArtworkUrlProviderElement(super.provider);

  @override
  String get id => (origin as ArtworkUrlProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
