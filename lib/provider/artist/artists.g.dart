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
    extends $NotifierProvider<PaginatedArtists, PaginatedArtistsState> {
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
  Override overrideWithValue(PaginatedArtistsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaginatedArtistsState>(value),
    );
  }
}

String _$paginatedArtistsHash() => r'fd37d80867caaf1dde9b2495cf36a30f41e05d16';

abstract class _$PaginatedArtists extends $Notifier<PaginatedArtistsState> {
  PaginatedArtistsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PaginatedArtistsState, PaginatedArtistsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaginatedArtistsState, PaginatedArtistsState>,
              PaginatedArtistsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
