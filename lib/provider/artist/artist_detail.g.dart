// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(artistDetail)
final artistDetailProvider = ArtistDetailFamily._();

final class ArtistDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  ArtistDetailProvider._({
    required ArtistDetailFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'artistDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$artistDetailHash();

  @override
  String toString() {
    return r'artistDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>?> create(Ref ref) {
    final argument = this.argument as String?;
    return artistDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistDetailHash() => r'28bad23aabe601e5a43e31e4eb935fffebd1874a';

final class ArtistDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  ArtistDetailFamily._()
    : super(
        retry: null,
        name: r'artistDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ArtistDetailProvider call(String? artistId) =>
      ArtistDetailProvider._(argument: artistId, from: this);

  @override
  String toString() => r'artistDetailProvider';
}
