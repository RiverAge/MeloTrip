// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaginatedSongList)
final paginatedSongListProvider = PaginatedSongListFamily._();

final class PaginatedSongListProvider
    extends
        $NotifierProvider<
          PaginatedSongList,
          PaginatedListSnapshot<SongEntity>
        > {
  PaginatedSongListProvider._({
    required PaginatedSongListFamily super.from,
    required SongSearchQuery super.argument,
  }) : super(
         retry: null,
         name: r'paginatedSongListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paginatedSongListHash();

  @override
  String toString() {
    return r'paginatedSongListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PaginatedSongList create() => PaginatedSongList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaginatedListSnapshot<SongEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaginatedListSnapshot<SongEntity>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedSongListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paginatedSongListHash() => r'93d3842f08a3f953c8a5efa5493654c2e5d5c9b5';

final class PaginatedSongListFamily extends $Family
    with
        $ClassFamilyOverride<
          PaginatedSongList,
          PaginatedListSnapshot<SongEntity>,
          PaginatedListSnapshot<SongEntity>,
          PaginatedListSnapshot<SongEntity>,
          SongSearchQuery
        > {
  PaginatedSongListFamily._()
    : super(
        retry: null,
        name: r'paginatedSongListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PaginatedSongListProvider call(SongSearchQuery query) =>
      PaginatedSongListProvider._(argument: query, from: this);

  @override
  String toString() => r'paginatedSongListProvider';
}

abstract class _$PaginatedSongList
    extends $Notifier<PaginatedListSnapshot<SongEntity>> {
  late final _$args = ref.$arg as SongSearchQuery;
  SongSearchQuery get query => _$args;

  PaginatedListSnapshot<SongEntity> build(SongSearchQuery query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              PaginatedListSnapshot<SongEntity>,
              PaginatedListSnapshot<SongEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PaginatedListSnapshot<SongEntity>,
                PaginatedListSnapshot<SongEntity>
              >,
              PaginatedListSnapshot<SongEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
