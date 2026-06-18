// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_artists.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for fetching similar artists based on an artist ID.
///
/// This provider calls Navidrome's getArtistInfo2 endpoint to get
/// similar artists recommendations.
///
/// Behavior:
/// - Returns empty list if artistId is null or empty.
/// - Returns empty list if the API returns no similar artists.
/// - Returns empty list on error (does not throw).
/// - Does NOT fallback to external links or getSimilarSongs2.
/// - Does NOT cache results to local database.

@ProviderFor(similarArtists)
final similarArtistsProvider = SimilarArtistsFamily._();

/// Provider for fetching similar artists based on an artist ID.
///
/// This provider calls Navidrome's getArtistInfo2 endpoint to get
/// similar artists recommendations.
///
/// Behavior:
/// - Returns empty list if artistId is null or empty.
/// - Returns empty list if the API returns no similar artists.
/// - Returns empty list on error (does not throw).
/// - Does NOT fallback to external links or getSimilarSongs2.
/// - Does NOT cache results to local database.

final class SimilarArtistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ArtistEntity>>,
          List<ArtistEntity>,
          FutureOr<List<ArtistEntity>>
        >
    with
        $FutureModifier<List<ArtistEntity>>,
        $FutureProvider<List<ArtistEntity>> {
  /// Provider for fetching similar artists based on an artist ID.
  ///
  /// This provider calls Navidrome's getArtistInfo2 endpoint to get
  /// similar artists recommendations.
  ///
  /// Behavior:
  /// - Returns empty list if artistId is null or empty.
  /// - Returns empty list if the API returns no similar artists.
  /// - Returns empty list on error (does not throw).
  /// - Does NOT fallback to external links or getSimilarSongs2.
  /// - Does NOT cache results to local database.
  SimilarArtistsProvider._({
    required SimilarArtistsFamily super.from,
    required ({String? artistId, int count}) super.argument,
  }) : super(
         retry: null,
         name: r'similarArtistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$similarArtistsHash();

  @override
  String toString() {
    return r'similarArtistsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ArtistEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArtistEntity>> create(Ref ref) {
    final argument = this.argument as ({String? artistId, int count});
    return similarArtists(
      ref,
      artistId: argument.artistId,
      count: argument.count,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarArtistsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$similarArtistsHash() => r'4a92c4dca0fd3e6280d1de0d7c8252563ffd916d';

/// Provider for fetching similar artists based on an artist ID.
///
/// This provider calls Navidrome's getArtistInfo2 endpoint to get
/// similar artists recommendations.
///
/// Behavior:
/// - Returns empty list if artistId is null or empty.
/// - Returns empty list if the API returns no similar artists.
/// - Returns empty list on error (does not throw).
/// - Does NOT fallback to external links or getSimilarSongs2.
/// - Does NOT cache results to local database.

final class SimilarArtistsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ArtistEntity>>,
          ({String? artistId, int count})
        > {
  SimilarArtistsFamily._()
    : super(
        retry: null,
        name: r'similarArtistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for fetching similar artists based on an artist ID.
  ///
  /// This provider calls Navidrome's getArtistInfo2 endpoint to get
  /// similar artists recommendations.
  ///
  /// Behavior:
  /// - Returns empty list if artistId is null or empty.
  /// - Returns empty list if the API returns no similar artists.
  /// - Returns empty list on error (does not throw).
  /// - Does NOT fallback to external links or getSimilarSongs2.
  /// - Does NOT cache results to local database.

  SimilarArtistsProvider call({required String? artistId, int count = 12}) =>
      SimilarArtistsProvider._(
        argument: (artistId: artistId, count: count),
        from: this,
      );

  @override
  String toString() => r'similarArtistsProvider';
}
