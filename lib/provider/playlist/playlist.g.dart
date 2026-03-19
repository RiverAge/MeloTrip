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

String _$playlistActionsHash() => r'57c9ea5a8687083af5911fb014233bed86ea784d';

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
          AsyncValue<Result<List<PlaylistEntity>, AppFailure>>,
          Result<List<PlaylistEntity>, AppFailure>,
          FutureOr<Result<List<PlaylistEntity>, AppFailure>>
        >
    with
        $FutureModifier<Result<List<PlaylistEntity>, AppFailure>>,
        $FutureProvider<Result<List<PlaylistEntity>, AppFailure>> {
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
  $FutureProviderElement<Result<List<PlaylistEntity>, AppFailure>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<PlaylistEntity>, AppFailure>> create(Ref ref) {
    return playlists(ref);
  }
}

String _$playlistsHash() => r'21291b42c42e90da9b773c627b7101d0216142aa';

@ProviderFor(PlaylistDetail)
final playlistDetailProvider = PlaylistDetailFamily._();

final class PlaylistDetailProvider
    extends
        $AsyncNotifierProvider<
          PlaylistDetail,
          Result<PlaylistEntity, AppFailure>?
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

String _$playlistDetailHash() => r'eed6993acb5d302970c2f74517a2cda8580f44bd';

final class PlaylistDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistDetail,
          AsyncValue<Result<PlaylistEntity, AppFailure>?>,
          Result<PlaylistEntity, AppFailure>?,
          FutureOr<Result<PlaylistEntity, AppFailure>?>,
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
    extends $AsyncNotifier<Result<PlaylistEntity, AppFailure>?> {
  late final _$args = ref.$arg as String?;
  String? get playlistId => _$args;

  FutureOr<Result<PlaylistEntity, AppFailure>?> build(String? playlistId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<PlaylistEntity, AppFailure>?>,
              Result<PlaylistEntity, AppFailure>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<PlaylistEntity, AppFailure>?>,
                Result<PlaylistEntity, AppFailure>?
              >,
              AsyncValue<Result<PlaylistEntity, AppFailure>?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
