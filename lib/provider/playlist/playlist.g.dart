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

String _$playlistActionsHash() => r'90bf2fc6a923b274952c89257e50615367c22d82';

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

@ProviderFor(playlists)
final playlistsProvider = PlaylistsProvider._();

final class PlaylistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>>,
          Result<SubsonicResponse, AppFailure>,
          FutureOr<Result<SubsonicResponse, AppFailure>>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>> {
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
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>> create(Ref ref) {
    return playlists(ref);
  }
}

String _$playlistsHash() => r'448da176760f45b0647df2a3ba1c3c247c2117fa';

@ProviderFor(PlaylistDetail)
final playlistDetailProvider = PlaylistDetailFamily._();

final class PlaylistDetailProvider
    extends
        $AsyncNotifierProvider<
          PlaylistDetail,
          Result<SubsonicResponse, AppFailure>?
        > {
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
  PlaylistDetail create() => PlaylistDetail();

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistDetailHash() => r'a0e68908b511a8bd86d66420b1ca11031df6a56d';

final class PlaylistDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistDetail,
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
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

abstract class _$PlaylistDetail
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
