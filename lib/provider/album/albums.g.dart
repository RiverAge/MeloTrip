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
          AsyncValue<List<AlbumEntity>>,
          List<AlbumEntity>,
          FutureOr<List<AlbumEntity>>
        >
    with
        $FutureModifier<List<AlbumEntity>>,
        $FutureProvider<List<AlbumEntity>> {
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
  $FutureProviderElement<List<AlbumEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AlbumEntity>> create(Ref ref) {
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

String _$albumsHash() => r'32ab7ec807b9b034e4f9d1c25e7a1feddc06e9d6';

final class AlbumsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AlbumEntity>>, AlumsType> {
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
