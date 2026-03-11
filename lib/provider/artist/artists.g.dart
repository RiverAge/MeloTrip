// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaginatedArtists)
final paginatedArtistsProvider = PaginatedArtistsProvider._();

final class PaginatedArtistsProvider
    extends
        $NotifierProvider<
          PaginatedArtists,
          PaginatedListSnapshot<ArtistIndexEntry>
        > {
  PaginatedArtistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paginatedArtistsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paginatedArtistsHash();

  @$internal
  @override
  PaginatedArtists create() => PaginatedArtists();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaginatedListSnapshot<ArtistIndexEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<PaginatedListSnapshot<ArtistIndexEntry>>(value),
    );
  }
}

String _$paginatedArtistsHash() => r'ba74f013d31b452e296af66542d368ed9d35cf52';

abstract class _$PaginatedArtists
    extends $Notifier<PaginatedListSnapshot<ArtistIndexEntry>> {
  PaginatedListSnapshot<ArtistIndexEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              PaginatedListSnapshot<ArtistIndexEntry>,
              PaginatedListSnapshot<ArtistIndexEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PaginatedListSnapshot<ArtistIndexEntry>,
                PaginatedListSnapshot<ArtistIndexEntry>
              >,
              PaginatedListSnapshot<ArtistIndexEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
