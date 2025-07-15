// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$albumDetailHash() => r'271e6bdebbf7054d4e35a3985048777e570a7933';

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

/// See also [albumDetail].
@ProviderFor(albumDetail)
const albumDetailProvider = AlbumDetailFamily();

/// See also [albumDetail].
class AlbumDetailFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [albumDetail].
  const AlbumDetailFamily();

  /// See also [albumDetail].
  AlbumDetailProvider call(String? albumId) {
    return AlbumDetailProvider(albumId);
  }

  @override
  AlbumDetailProvider getProviderOverride(
    covariant AlbumDetailProvider provider,
  ) {
    return call(provider.albumId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'albumDetailProvider';
}

/// See also [albumDetail].
class AlbumDetailProvider extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [albumDetail].
  AlbumDetailProvider(String? albumId)
    : this._internal(
        (ref) => albumDetail(ref as AlbumDetailRef, albumId),
        from: albumDetailProvider,
        name: r'albumDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$albumDetailHash,
        dependencies: AlbumDetailFamily._dependencies,
        allTransitiveDependencies: AlbumDetailFamily._allTransitiveDependencies,
        albumId: albumId,
      );

  AlbumDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.albumId,
  }) : super.internal();

  final String? albumId;

  @override
  Override overrideWith(
    FutureOr<SubsonicResponse?> Function(AlbumDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlbumDetailProvider._internal(
        (ref) => create(ref as AlbumDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        albumId: albumId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubsonicResponse?> createElement() {
    return _AlbumDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailProvider && other.albumId == albumId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, albumId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlbumDetailRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `albumId` of this provider.
  String? get albumId;
}

class _AlbumDetailProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with AlbumDetailRef {
  _AlbumDetailProviderElement(super.provider);

  @override
  String? get albumId => (origin as AlbumDetailProvider).albumId;
}

String _$albumFavoriteHash() => r'1689d9a38bf3640d81f5ce9a8ce8ea51a37b166b';

/// See also [AlbumFavorite].
@ProviderFor(AlbumFavorite)
final albumFavoriteProvider =
    AutoDisposeAsyncNotifierProvider<AlbumFavorite, SubsonicResponse?>.internal(
      AlbumFavorite.new,
      name: r'albumFavoriteProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$albumFavoriteHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AlbumFavorite = AutoDisposeAsyncNotifier<SubsonicResponse?>;
String _$albumRatingHash() => r'b4c0b56a734ac43cd5c5694606093249765737d4';

/// See also [AlbumRating].
@ProviderFor(AlbumRating)
final albumRatingProvider =
    AutoDisposeAsyncNotifierProvider<AlbumRating, SubsonicResponse?>.internal(
      AlbumRating.new,
      name: r'albumRatingProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$albumRatingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AlbumRating = AutoDisposeAsyncNotifier<SubsonicResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
