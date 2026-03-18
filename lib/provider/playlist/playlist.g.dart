// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Playlists)
final playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider
    extends $AsyncNotifierProvider<Playlists, SubsonicResponse?> {
  PlaylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsHash();

  @$internal
  @override
  Playlists create() => Playlists();
}

String _$playlistsHash() => r'b7368d2c3a10c55fa2fbfaa4fd4c1ddb5e06a51e';

abstract class _$Playlists extends $AsyncNotifier<SubsonicResponse?> {
  FutureOr<SubsonicResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubsonicResponse?>, SubsonicResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubsonicResponse?>, SubsonicResponse?>,
              AsyncValue<SubsonicResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(playlistDetail)
final playlistDetailProvider = PlaylistDetailFamily._();

final class PlaylistDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
  PlaylistDetailProvider._({
    required PlaylistDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'playlistDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistDetailHash();

  @override
  String toString() {
    return r'playlistDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SubsonicResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubsonicResponse?> create(Ref ref) {
    final argument = this.argument as String?;
    return playlistDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistDetailHash() => r'2931a1c3c45da9ac8ab1ae68dc81a9b9e0d32d0c';

final class PlaylistDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, String?> {
  PlaylistDetailFamily._()
    : super(
        retry: null,
        name: r'playlistDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistDetailProvider call(String? playlistId) =>
      PlaylistDetailProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistDetailProvider';
}

@ProviderFor(PlaylistUpdate)
final playlistUpdateProvider = PlaylistUpdateProvider._();

final class PlaylistUpdateProvider
    extends $AsyncNotifierProvider<PlaylistUpdate, SubsonicResponse?> {
  PlaylistUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistUpdateHash();

  @$internal
  @override
  PlaylistUpdate create() => PlaylistUpdate();
}

String _$playlistUpdateHash() => r'2e5a8fb0786e11e1e8ec6d27942b5e74ab26ac78';

abstract class _$PlaylistUpdate extends $AsyncNotifier<SubsonicResponse?> {
  FutureOr<SubsonicResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubsonicResponse?>, SubsonicResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubsonicResponse?>, SubsonicResponse?>,
              AsyncValue<SubsonicResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(playlistsResult)
final playlistsResultProvider = PlaylistsResultProvider._();

final class PlaylistsResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>>,
          Result<SubsonicResponse, AppFailure>,
          FutureOr<Result<SubsonicResponse, AppFailure>>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>> {
  PlaylistsResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsResultHash();

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>> create(Ref ref) {
    return playlistsResult(ref);
  }
}

String _$playlistsResultHash() => r'1b9b6c77f82de8ee9b53ea4ec2c649cc45bf6f42';

@ProviderFor(playlistDetailResult)
final playlistDetailResultProvider = PlaylistDetailResultFamily._();

final class PlaylistDetailResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  PlaylistDetailResultProvider._({
    required PlaylistDetailResultFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'playlistDetailResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistDetailResultHash();

  @override
  String toString() {
    return r'playlistDetailResultProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>?> create(Ref ref) {
    final argument = this.argument as String?;
    return playlistDetailResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistDetailResultHash() =>
    r'3dae4e6f6539ccc151a466dfc2ea4e0a155dd701';

final class PlaylistDetailResultFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  PlaylistDetailResultFamily._()
    : super(
        retry: null,
        name: r'playlistDetailResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistDetailResultProvider call(String? playlistId) =>
      PlaylistDetailResultProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistDetailResultProvider';
}
