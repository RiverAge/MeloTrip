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

String _$playlistActionsHash() => r'80635744a0bfd3f09a08b74d731fbfaa1c33f2d3';

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

@ProviderFor(PlaylistDetailResult)
final playlistDetailResultProvider = PlaylistDetailResultFamily._();

final class PlaylistDetailResultProvider
    extends
        $AsyncNotifierProvider<
          PlaylistDetailResult,
          Result<SubsonicResponse, AppFailure>?
        > {
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
  PlaylistDetailResult create() => PlaylistDetailResult();

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
    r'eb729e50a01892296c82460b52773c36afd47396';

final class PlaylistDetailResultFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistDetailResult,
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
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

abstract class _$PlaylistDetailResult
    extends $AsyncNotifier<Result<SubsonicResponse, AppFailure>?> {
  late final _$args = ref.$arg as String?;
  String? get playlistId => _$args;

  FutureOr<Result<SubsonicResponse, AppFailure>?> build(String? playlistId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<SubsonicResponse, AppFailure>?>,
              Result<SubsonicResponse, AppFailure>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<SubsonicResponse, AppFailure>?>,
                Result<SubsonicResponse, AppFailure>?
              >,
              AsyncValue<Result<SubsonicResponse, AppFailure>?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
