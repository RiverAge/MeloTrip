// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$albumsHash() => r'be91a2588a193ceb783b3b14746f0161c065c242';

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

/// See also [albums].
@ProviderFor(albums)
const albumsProvider = AlbumsFamily();

/// See also [albums].
class AlbumsFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [albums].
  const AlbumsFamily();

  /// See also [albums].
  AlbumsProvider call(AlumsType type) {
    return AlbumsProvider(type);
  }

  @override
  AlbumsProvider getProviderOverride(covariant AlbumsProvider provider) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'albumsProvider';
}

/// See also [albums].
class AlbumsProvider extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [albums].
  AlbumsProvider(AlumsType type)
    : this._internal(
        (ref) => albums(ref as AlbumsRef, type),
        from: albumsProvider,
        name: r'albumsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$albumsHash,
        dependencies: AlbumsFamily._dependencies,
        allTransitiveDependencies: AlbumsFamily._allTransitiveDependencies,
        type: type,
      );

  AlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final AlumsType type;

  @override
  Override overrideWith(
    FutureOr<SubsonicResponse?> Function(AlbumsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlbumsProvider._internal(
        (ref) => create(ref as AlbumsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubsonicResponse?> createElement() {
    return _AlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumsProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlbumsRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `type` of this provider.
  AlumsType get type;
}

class _AlbumsProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with AlbumsRef {
  _AlbumsProviderElement(super.provider);

  @override
  AlumsType get type => (origin as AlbumsProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
