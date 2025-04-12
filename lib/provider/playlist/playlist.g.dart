// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistDetailHash() => r'815f5cb5233bb861bd6a4f06e21cfa2bb722d085';

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

/// See also [playlistDetail].
@ProviderFor(playlistDetail)
const playlistDetailProvider = PlaylistDetailFamily();

/// See also [playlistDetail].
class PlaylistDetailFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [playlistDetail].
  const PlaylistDetailFamily();

  /// See also [playlistDetail].
  PlaylistDetailProvider call(String? playlistId) {
    return PlaylistDetailProvider(playlistId);
  }

  @override
  PlaylistDetailProvider getProviderOverride(
    covariant PlaylistDetailProvider provider,
  ) {
    return call(provider.playlistId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playlistDetailProvider';
}

/// See also [playlistDetail].
class PlaylistDetailProvider
    extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [playlistDetail].
  PlaylistDetailProvider(String? playlistId)
    : this._internal(
        (ref) => playlistDetail(ref as PlaylistDetailRef, playlistId),
        from: playlistDetailProvider,
        name: r'playlistDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$playlistDetailHash,
        dependencies: PlaylistDetailFamily._dependencies,
        allTransitiveDependencies:
            PlaylistDetailFamily._allTransitiveDependencies,
        playlistId: playlistId,
      );

  PlaylistDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playlistId,
  }) : super.internal();

  final String? playlistId;

  @override
  Override overrideWith(
    FutureOr<SubsonicResponse?> Function(PlaylistDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaylistDetailProvider._internal(
        (ref) => create(ref as PlaylistDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playlistId: playlistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubsonicResponse?> createElement() {
    return _PlaylistDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailProvider && other.playlistId == playlistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playlistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaylistDetailRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `playlistId` of this provider.
  String? get playlistId;
}

class _PlaylistDetailProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with PlaylistDetailRef {
  _PlaylistDetailProviderElement(super.provider);

  @override
  String? get playlistId => (origin as PlaylistDetailProvider).playlistId;
}

String _$playlistsHash() => r'dec1055fcd4fefe98d793d398d414a495a22e3ae';

/// See also [Playlists].
@ProviderFor(Playlists)
final playlistsProvider =
    AutoDisposeAsyncNotifierProvider<Playlists, SubsonicResponse?>.internal(
      Playlists.new,
      name: r'playlistsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$playlistsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Playlists = AutoDisposeAsyncNotifier<SubsonicResponse?>;
String _$playlistUpdateHash() => r'1db3b7dbadb5f6fa5387291ad7ba0057b55abdf8';

/// See also [PlaylistUpdate].
@ProviderFor(PlaylistUpdate)
final playlistUpdateProvider = AutoDisposeAsyncNotifierProvider<
  PlaylistUpdate,
  SubsonicResponse?
>.internal(
  PlaylistUpdate.new,
  name: r'playlistUpdateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$playlistUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaylistUpdate = AutoDisposeAsyncNotifier<SubsonicResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
