// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaylistActions)
final playlistActionsProvider = PlaylistActionsProvider._();

final class PlaylistActionsProvider
    extends $AsyncNotifierProvider<PlaylistActions, void> {
  PlaylistActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistActionsHash();

  @$internal
  @override
  PlaylistActions create() => PlaylistActions();
}

String _$playlistActionsHash() => r'e79a39719ea55c9892fe63b2f3908a7a4680599d';

abstract class _$PlaylistActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
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

String _$playlistUpdateHash() => r'6823a5e395168c865c79266ddaedbd3843ab7986';

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
