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
    r'bd74d02e8386b5a010348101aeb5849a7dca8901';

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
          AsyncValue<Result<List<AlbumEntity>, AppFailure>>,
          Result<List<AlbumEntity>, AppFailure>,
          FutureOr<Result<List<AlbumEntity>, AppFailure>>
        >
    with
        $FutureModifier<Result<List<AlbumEntity>, AppFailure>>,
        $FutureProvider<Result<List<AlbumEntity>, AppFailure>> {
  AlbumListProvider._({
    required AlbumListFamily super.from,
    required AlbumListQuery super.argument,
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
  $FutureProviderElement<Result<List<AlbumEntity>, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<AlbumEntity>, AppFailure>> create(Ref ref) {
    final argument = this.argument as AlbumListQuery;
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

String _$albumListHash() => r'48ae68d9136f25f6d663da381bf5d63746f3c333';

final class AlbumListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<AlbumEntity>, AppFailure>>,
          AlbumListQuery
        > {
  AlbumListFamily._()
    : super(
        retry: null,
        name: r'albumListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumListProvider call(AlbumListQuery query) =>
      AlbumListProvider._(argument: query, from: this);

  @override
  String toString() => r'albumListProvider';
}
