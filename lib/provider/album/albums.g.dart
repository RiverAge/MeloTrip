// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaginatedAlbumList)
final paginatedAlbumListProvider = PaginatedAlbumListFamily._();

final class PaginatedAlbumListProvider
    extends
        $NotifierProvider<
          PaginatedAlbumList,
          PaginatedListSnapshot<AlbumEntity>
        > {
  PaginatedAlbumListProvider._({
    required PaginatedAlbumListFamily super.from,
    required AlbumListQuery super.argument,
  }) : super(
         retry: null,
         name: r'paginatedAlbumListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paginatedAlbumListHash();

  @override
  String toString() {
    return r'paginatedAlbumListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PaginatedAlbumList create() => PaginatedAlbumList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaginatedListSnapshot<AlbumEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaginatedListSnapshot<AlbumEntity>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedAlbumListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paginatedAlbumListHash() =>
    r'177c7e1ff15d318d0f0878991eadbda9bdadfa8e';

final class PaginatedAlbumListFamily extends $Family
    with
        $ClassFamilyOverride<
          PaginatedAlbumList,
          PaginatedListSnapshot<AlbumEntity>,
          PaginatedListSnapshot<AlbumEntity>,
          PaginatedListSnapshot<AlbumEntity>,
          AlbumListQuery
        > {
  PaginatedAlbumListFamily._()
    : super(
        retry: null,
        name: r'paginatedAlbumListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PaginatedAlbumListProvider call(AlbumListQuery query) =>
      PaginatedAlbumListProvider._(argument: query, from: this);

  @override
  String toString() => r'paginatedAlbumListProvider';
}

abstract class _$PaginatedAlbumList
    extends $Notifier<PaginatedListSnapshot<AlbumEntity>> {
  late final _$args = ref.$arg as AlbumListQuery;
  AlbumListQuery get query => _$args;

  PaginatedListSnapshot<AlbumEntity> build(AlbumListQuery query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              PaginatedListSnapshot<AlbumEntity>,
              PaginatedListSnapshot<AlbumEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PaginatedListSnapshot<AlbumEntity>,
                PaginatedListSnapshot<AlbumEntity>
              >,
              PaginatedListSnapshot<AlbumEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(albumList)
final albumListProvider = AlbumListFamily._();

final class AlbumListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AlbumEntity>>,
          List<AlbumEntity>,
          FutureOr<List<AlbumEntity>>
        >
    with
        $FutureModifier<List<AlbumEntity>>,
        $FutureProvider<List<AlbumEntity>> {
  AlbumListProvider._({
    required AlbumListFamily super.from,
    required AlbumListType super.argument,
  }) : super(
         retry: null,
         name: r'albumListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumListHash();

  @override
  String toString() {
    return r'albumListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AlbumEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AlbumEntity>> create(Ref ref) {
    final argument = this.argument as AlbumListType;
    return albumList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumListHash() => r'cf638040d9fd6a0d3fab8abcbfaa67eebcdf55eb';

final class AlbumListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AlbumEntity>>, AlbumListType> {
  AlbumListFamily._()
    : super(
        retry: null,
        name: r'albumListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumListProvider call(AlbumListType type) =>
      AlbumListProvider._(argument: type, from: this);

  @override
  String toString() => r'albumListProvider';
}
