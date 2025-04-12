// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lyricsHash() => r'16e2f89cae582a9dff9f0f10d22f7484c3f89c54';

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

/// See also [lyrics].
@ProviderFor(lyrics)
const lyricsProvider = LyricsFamily();

/// See also [lyrics].
class LyricsFamily extends Family<AsyncValue<SubsonicResponse?>> {
  /// See also [lyrics].
  const LyricsFamily();

  /// See also [lyrics].
  LyricsProvider call(String? songId) {
    return LyricsProvider(songId);
  }

  @override
  LyricsProvider getProviderOverride(covariant LyricsProvider provider) {
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
  String? get name => r'lyricsProvider';
}

/// See also [lyrics].
class LyricsProvider extends AutoDisposeFutureProvider<SubsonicResponse?> {
  /// See also [lyrics].
  LyricsProvider(String? songId)
    : this._internal(
        (ref) => lyrics(ref as LyricsRef, songId),
        from: lyricsProvider,
        name: r'lyricsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$lyricsHash,
        dependencies: LyricsFamily._dependencies,
        allTransitiveDependencies: LyricsFamily._allTransitiveDependencies,
        songId: songId,
      );

  LyricsProvider._internal(
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
    FutureOr<SubsonicResponse?> Function(LyricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LyricsProvider._internal(
        (ref) => create(ref as LyricsRef),
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
    return _LyricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LyricsProvider && other.songId == songId;
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
mixin LyricsRef on AutoDisposeFutureProviderRef<SubsonicResponse?> {
  /// The parameter `songId` of this provider.
  String? get songId;
}

class _LyricsProviderElement
    extends AutoDisposeFutureProviderElement<SubsonicResponse?>
    with LyricsRef {
  _LyricsProviderElement(super.provider);

  @override
  String? get songId => (origin as LyricsProvider).songId;
}

String _$lyricsOfLineHash() => r'2a90b03372f696a04f2e6f0c007e4de9c4592765';

/// See also [lyricsOfLine].
@ProviderFor(lyricsOfLine)
const lyricsOfLineProvider = LyricsOfLineFamily();

/// See also [lyricsOfLine].
class LyricsOfLineFamily extends Family<String> {
  /// See also [lyricsOfLine].
  const LyricsOfLineFamily();

  /// See also [lyricsOfLine].
  LyricsOfLineProvider call(SubsonicResponse lyrics, Duration position) {
    return LyricsOfLineProvider(lyrics, position);
  }

  @override
  LyricsOfLineProvider getProviderOverride(
    covariant LyricsOfLineProvider provider,
  ) {
    return call(provider.lyrics, provider.position);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lyricsOfLineProvider';
}

/// See also [lyricsOfLine].
class LyricsOfLineProvider extends AutoDisposeProvider<String> {
  /// See also [lyricsOfLine].
  LyricsOfLineProvider(SubsonicResponse lyrics, Duration position)
    : this._internal(
        (ref) => lyricsOfLine(ref as LyricsOfLineRef, lyrics, position),
        from: lyricsOfLineProvider,
        name: r'lyricsOfLineProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lyricsOfLineHash,
        dependencies: LyricsOfLineFamily._dependencies,
        allTransitiveDependencies:
            LyricsOfLineFamily._allTransitiveDependencies,
        lyrics: lyrics,
        position: position,
      );

  LyricsOfLineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lyrics,
    required this.position,
  }) : super.internal();

  final SubsonicResponse lyrics;
  final Duration position;

  @override
  Override overrideWith(String Function(LyricsOfLineRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: LyricsOfLineProvider._internal(
        (ref) => create(ref as LyricsOfLineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lyrics: lyrics,
        position: position,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _LyricsOfLineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LyricsOfLineProvider &&
        other.lyrics == lyrics &&
        other.position == position;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lyrics.hashCode);
    hash = _SystemHash.combine(hash, position.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LyricsOfLineRef on AutoDisposeProviderRef<String> {
  /// The parameter `lyrics` of this provider.
  SubsonicResponse get lyrics;

  /// The parameter `position` of this provider.
  Duration get position;
}

class _LyricsOfLineProviderElement extends AutoDisposeProviderElement<String>
    with LyricsOfLineRef {
  _LyricsOfLineProviderElement(super.provider);

  @override
  SubsonicResponse get lyrics => (origin as LyricsOfLineProvider).lyrics;
  @override
  Duration get position => (origin as LyricsOfLineProvider).position;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
