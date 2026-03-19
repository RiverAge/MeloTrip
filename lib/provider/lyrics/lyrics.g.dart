// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lyrics)
final lyricsProvider = LyricsFamily._();

final class LyricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>?>,
          Result<SubsonicResponse, AppFailure>?,
          FutureOr<Result<SubsonicResponse, AppFailure>?>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>?>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>?> {
  LyricsProvider._({
    required LyricsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'lyricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lyricsHash();

  @override
  String toString() {
    return r'lyricsProvider'
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
    return lyrics(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LyricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lyricsHash() => r'b668365a64a15b6d13a722c617fc8f5de15fd7d8';

final class LyricsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SubsonicResponse, AppFailure>?>,
          String?
        > {
  LyricsFamily._()
    : super(
        retry: null,
        name: r'lyricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LyricsProvider call(String? songId) =>
      LyricsProvider._(argument: songId, from: this);

  @override
  String toString() => r'lyricsProvider';
}
