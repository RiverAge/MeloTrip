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
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
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
  $FutureProviderElement<SubsonicResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubsonicResponse?> create(Ref ref) {
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

String _$artistDetailHash() => r'29db6e90afee5fcd885e06c1f50c76b2f21a5e9a';

final class ArtistDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, String?> {
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

@ProviderFor(artistDetailResult)
final artistDetailResultProvider = ArtistDetailResultFamily._();

final class ArtistDetailResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  ArtistDetailResultProvider._({
    required ArtistDetailResultFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'artistDetailResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$artistDetailResultHash();

  @override
  String toString() {
    return r'artistDetailResultProvider'
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
    return artistDetailResult(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistDetailResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$artistDetailResultHash() =>
    r'dc0c287fa6af15dff00f53c947988f2b4564df4d';

final class ArtistDetailResultFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  ArtistDetailResultFamily._()
    : super(
        retry: null,
        name: r'artistDetailResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ArtistDetailResultProvider call(String? artistId) =>
      ArtistDetailResultProvider._(argument: artistId, from: this);

  @override
  String toString() => r'artistDetailResultProvider';
}
