// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_weighted_seeds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playlistWeightedSeeds)
final playlistWeightedSeedsProvider = PlaylistWeightedSeedsFamily._();

final class PlaylistWeightedSeedsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeightedSeed>>,
          List<WeightedSeed>,
          FutureOr<List<WeightedSeed>>
        >
    with
        $FutureModifier<List<WeightedSeed>>,
        $FutureProvider<List<WeightedSeed>> {
  PlaylistWeightedSeedsProvider._({
    required PlaylistWeightedSeedsFamily super.from,
    required ({int maxPlaylists, int maxSeeds}) super.argument,
  }) : super(
         retry: null,
         name: r'playlistWeightedSeedsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistWeightedSeedsHash();

  @override
  String toString() {
    return r'playlistWeightedSeedsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeightedSeed>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeightedSeed>> create(Ref ref) {
    final argument = this.argument as ({int maxPlaylists, int maxSeeds});
    return playlistWeightedSeeds(
      ref,
      maxPlaylists: argument.maxPlaylists,
      maxSeeds: argument.maxSeeds,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistWeightedSeedsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistWeightedSeedsHash() =>
    r'9479db0d8de7af1dab3858ef4277bdf783cd5872';

final class PlaylistWeightedSeedsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WeightedSeed>>,
          ({int maxPlaylists, int maxSeeds})
        > {
  PlaylistWeightedSeedsFamily._()
    : super(
        retry: null,
        name: r'playlistWeightedSeedsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistWeightedSeedsProvider call({
    int maxPlaylists = 3,
    int maxSeeds = 8,
  }) => PlaylistWeightedSeedsProvider._(
    argument: (maxPlaylists: maxPlaylists, maxSeeds: maxSeeds),
    from: this,
  );

  @override
  String toString() => r'playlistWeightedSeedsProvider';
}
