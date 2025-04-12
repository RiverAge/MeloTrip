// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$artistDetailHash() => r'd72211eaf0c724d6073dbd02ef46b77e6d56c819';

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

/// See also [artistDetail].
@ProviderFor(artistDetail)
const artistDetailProvider = ArtistDetailFamily();

/// See also [artistDetail].
class ArtistDetailFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [artistDetail].
  const ArtistDetailFamily();

  /// See also [artistDetail].
  ArtistDetailProvider call(String? artistId) {
    return ArtistDetailProvider(artistId);
  }

  @override
  ArtistDetailProvider getProviderOverride(
    covariant ArtistDetailProvider provider,
  ) {
    return call(provider.artistId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'artistDetailProvider';
}

/// See also [artistDetail].
class ArtistDetailProvider
    extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [artistDetail].
  ArtistDetailProvider(String? artistId)
    : this._internal(
        (ref) => artistDetail(ref as ArtistDetailRef, artistId),
        from: artistDetailProvider,
        name: r'artistDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$artistDetailHash,
        dependencies: ArtistDetailFamily._dependencies,
        allTransitiveDependencies:
            ArtistDetailFamily._allTransitiveDependencies,
        artistId: artistId,
      );

  ArtistDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artistId,
  }) : super.internal();

  final String? artistId;

  @override
  Override overrideWith(
    FutureOr<SubsonicResponse?> Function(ArtistDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArtistDetailProvider._internal(
        (ref) => create(ref as ArtistDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artistId: artistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubsonicResponse?> createElement() {
    return _ArtistDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistDetailProvider && other.artistId == artistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArtistDetailRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `artistId` of this provider.
  String? get artistId;
}

class _ArtistDetailProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with ArtistDetailRef {
  _ArtistDetailProviderElement(super.provider);

  @override
  String? get artistId => (origin as ArtistDetailProvider).artistId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
