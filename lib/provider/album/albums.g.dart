// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(albums)
final albumsProvider = AlbumsFamily._();

final class AlbumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
  AlbumsProvider._({
    required AlbumsFamily super.from,
    required AlumsType super.argument,
  }) : super(
         retry: null,
         name: r'albumsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumsHash();

  @override
  String toString() {
    return r'albumsProvider'
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
    final argument = this.argument as AlumsType;
    return albums(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumsHash() => r'be91a2588a193ceb783b3b14746f0161c065c242';

final class AlbumsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubsonicResponse?>, AlumsType> {
  AlbumsFamily._()
    : super(
        retry: null,
        name: r'albumsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumsProvider call(AlumsType type) =>
      AlbumsProvider._(argument: type, from: this);

  @override
  String toString() => r'albumsProvider';
}
