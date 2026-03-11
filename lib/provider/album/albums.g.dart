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
    extends $NotifierProvider<PaginatedAlbumList, PaginatedAlbumListState> {
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
  Override overrideWithValue(PaginatedAlbumListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaginatedAlbumListState>(value),
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
    r'0a1fdae59f1f52a220f788abe270cd3e81a349ad';

final class PaginatedAlbumListFamily extends $Family
    with
        $ClassFamilyOverride<
          PaginatedAlbumList,
          PaginatedAlbumListState,
          PaginatedAlbumListState,
          PaginatedAlbumListState,
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

abstract class _$PaginatedAlbumList extends $Notifier<PaginatedAlbumListState> {
  late final _$args = ref.$arg as AlbumListQuery;
  AlbumListQuery get query => _$args;

  PaginatedAlbumListState build(AlbumListQuery query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<PaginatedAlbumListState, PaginatedAlbumListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaginatedAlbumListState, PaginatedAlbumListState>,
              PaginatedAlbumListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(albums)
final albumsProvider = AlbumsFamily._();

final class AlbumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AlbumEntity>>,
          List<AlbumEntity>,
          FutureOr<List<AlbumEntity>>
        >
    with
        $FutureModifier<List<AlbumEntity>>,
        $FutureProvider<List<AlbumEntity>> {
  AlbumsProvider._({
    required AlbumsFamily super.from,
    required AlumsType super.argument,
  }) : super(
         retry: null,
         name: r'albumsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumsHash();

  @override
  String toString() {
    return r'albumsProvider'
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
    final argument = this.argument as AlumsType;
    return albums(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumsHash() => r'0cb26c2892af03c4c81f02b0f56ac7c626600f34';

final class AlbumsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AlbumEntity>>, AlumsType> {
  AlbumsFamily._()
    : super(
        retry: null,
        name: r'albumsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumsProvider call(AlumsType type) =>
      AlbumsProvider._(argument: type, from: this);

  @override
  String toString() => r'albumsProvider';
}
