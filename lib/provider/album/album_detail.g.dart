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
    extends $AsyncNotifierProvider<AlbumDetail, SubsonicResponse?> {
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

String _$albumDetailHash() => r'd084fe96c8536d06a47a183fde88065a4366339a';

final class AlbumDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumDetail,
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>,
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

abstract class _$AlbumDetail extends $AsyncNotifier<SubsonicResponse?> {
  late final _$args = ref.$arg as String?;
  String? get albumId => _$args;

  FutureOr<SubsonicResponse?> build(String? albumId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
