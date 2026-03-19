// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SongDetail)
final songDetailProvider = SongDetailFamily._();

final class SongDetailProvider
    extends
        $AsyncNotifierProvider<
          SongDetail,
          Result<SubsonicResponse, AppFailure>?
        > {
  SongDetailProvider._({
    required SongDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'songDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$songDetailHash();

  @override
  String toString() {
    return r'songDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SongDetail create() => SongDetail();

  @override
  bool operator ==(Object other) {
    return other is SongDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$songDetailHash() => r'7f323067950162a07a256112b46dc07910dbf07f';

final class SongDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          SongDetail,
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  SongDetailFamily._()
    : super(
        retry: null,
        name: r'songDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SongDetailProvider call(String? songId) =>
      SongDetailProvider._(argument: songId, from: this);

  @override
  String toString() => r'songDetailProvider';
}

abstract class _$SongDetail
    extends $AsyncNotifier<Result<SubsonicResponse, AppFailure>?> {
  late final _$args = ref.$arg as String?;
  String? get songId => _$args;

  FutureOr<Result<SubsonicResponse, AppFailure>?> build(String? songId);
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
