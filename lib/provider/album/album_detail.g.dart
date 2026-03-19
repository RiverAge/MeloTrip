// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumDetail)
final albumDetailProvider = AlbumDetailFamily._();

final class AlbumDetailProvider
    extends
        $AsyncNotifierProvider<
          AlbumDetail,
          Result<SubsonicResponse, AppFailure>?
        > {
  AlbumDetailProvider._({
    required AlbumDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'albumDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumDetailHash();

  @override
  String toString() {
    return r'albumDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlbumDetail create() => AlbumDetail();

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumDetailHash() => r'250d85bf14714918ac51bd61fef7ffcb690292a0';

final class AlbumDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumDetail,
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  AlbumDetailFamily._()
    : super(
        retry: null,
        name: r'albumDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumDetailProvider call(String? albumId) =>
      AlbumDetailProvider._(argument: albumId, from: this);

  @override
  String toString() => r'albumDetailProvider';
}

abstract class _$AlbumDetail
    extends $AsyncNotifier<Result<SubsonicResponse, AppFailure>?> {
  late final _$args = ref.$arg as String?;
  String? get albumId => _$args;

  FutureOr<Result<SubsonicResponse, AppFailure>?> build(String? albumId);
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
