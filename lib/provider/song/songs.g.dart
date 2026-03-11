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
    extends $NotifierProvider<PaginatedSongList, PaginatedSongListState> {
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
  Override overrideWithValue(PaginatedSongListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaginatedSongListState>(value),
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

String _$paginatedSongListHash() => r'ad819dd576774a260d65bca4d1f52fcf5903e521';

final class PaginatedSongListFamily extends $Family
    with
        $ClassFamilyOverride<
          PaginatedSongList,
          PaginatedSongListState,
          PaginatedSongListState,
          PaginatedSongListState,
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

abstract class _$PaginatedSongList extends $Notifier<PaginatedSongListState> {
  late final _$args = ref.$arg as SongSearchQuery;
  SongSearchQuery get query => _$args;

  PaginatedSongListState build(SongSearchQuery query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<PaginatedSongListState, PaginatedSongListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaginatedSongListState, PaginatedSongListState>,
              PaginatedSongListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
