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
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
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
  $FutureProviderElement<SubsonicResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubsonicResponse?> create(Ref ref) {
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

String _$lyricsHash() => r'b36289f58fcdc88735b0865159b27eb9fe4f63d6';

final class LyricsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, String?> {
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
