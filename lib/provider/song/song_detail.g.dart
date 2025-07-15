// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songDetailHash() => r'c1b5862c8fe072b93f0b07f671557b63cdd38c3d';

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

/// See also [songDetail].
@ProviderFor(songDetail)
const songDetailProvider = SongDetailFamily();

/// See also [songDetail].
class SongDetailFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [songDetail].
  const SongDetailFamily();

  /// See also [songDetail].
  SongDetailProvider call(String? songId) {
    return SongDetailProvider(songId);
  }

  @override
  SongDetailProvider getProviderOverride(
    covariant SongDetailProvider provider,
  ) {
    return call(provider.songId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'songDetailProvider';
}

/// See also [songDetail].
class SongDetailProvider extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [songDetail].
  SongDetailProvider(String? songId)
    : this._internal(
        (ref) => songDetail(ref as SongDetailRef, songId),
        from: songDetailProvider,
        name: r'songDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$songDetailHash,
        dependencies: SongDetailFamily._dependencies,
        allTransitiveDependencies: SongDetailFamily._allTransitiveDependencies,
        songId: songId,
      );

  SongDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songId,
  }) : super.internal();

  final String? songId;

  @override
  Override overrideWith(
    FutureOr<SubsonicResponse?> Function(SongDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongDetailProvider._internal(
        (ref) => create(ref as SongDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songId: songId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubsonicResponse?> createElement() {
    return _SongDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongDetailProvider && other.songId == songId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SongDetailRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `songId` of this provider.
  String? get songId;
}

class _SongDetailProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with SongDetailRef {
  _SongDetailProviderElement(super.provider);

  @override
  String? get songId => (origin as SongDetailProvider).songId;
}

String _$songFavoriteHash() => r'cf5e8af3c48931ebdfb2b4808a7069403703bf09';

/// See also [SongFavorite].
@ProviderFor(SongFavorite)
final songFavoriteProvider =
    AutoDisposeAsyncNotifierProvider<SongFavorite, SubsonicResponse?>.internal(
      SongFavorite.new,
      name: r'songFavoriteProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$songFavoriteHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SongFavorite = AutoDisposeAsyncNotifier<SubsonicResponse?>;
String _$songRatingHash() => r'70a8c77d55220ed6ffda289c14ffa460a7c6c4cd';

/// See also [SongRating].
@ProviderFor(SongRating)
final songRatingProvider =
    AutoDisposeAsyncNotifierProvider<SongRating, SubsonicResponse?>.internal(
      SongRating.new,
      name: r'songRatingProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$songRatingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SongRating = AutoDisposeAsyncNotifier<SubsonicResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
