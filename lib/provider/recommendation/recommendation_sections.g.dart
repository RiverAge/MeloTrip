// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_sections.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyRecommendations)
final dailyRecommendationsProvider = DailyRecommendationsFamily._();

final class DailyRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>
        >
    with $FutureModifier<List<SongEntity>>, $FutureProvider<List<SongEntity>> {
  DailyRecommendationsProvider._({
    required DailyRecommendationsFamily super.from,
    required ({int limit, int refreshNonce}) super.argument,
  }) : super(
         retry: null,
         name: r'dailyRecommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyRecommendationsHash();

  @override
  String toString() {
    return r'dailyRecommendationsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SongEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongEntity>> create(Ref ref) {
    final argument = this.argument as ({int limit, int refreshNonce});
    return dailyRecommendations(
      ref,
      limit: argument.limit,
      refreshNonce: argument.refreshNonce,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DailyRecommendationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyRecommendationsHash() =>
    r'dba9c752ad6fa5b2bee318cbd17feae350ad0c80';

final class DailyRecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SongEntity>>,
          ({int limit, int refreshNonce})
        > {
  DailyRecommendationsFamily._()
    : super(
        retry: null,
        name: r'dailyRecommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyRecommendationsProvider call({int limit = 30, int refreshNonce = 0}) =>
      DailyRecommendationsProvider._(
        argument: (limit: limit, refreshNonce: refreshNonce),
        from: this,
      );

  @override
  String toString() => r'dailyRecommendationsProvider';
}

@ProviderFor(favoriteBasedRecommendations)
final favoriteBasedRecommendationsProvider =
    FavoriteBasedRecommendationsFamily._();

final class FavoriteBasedRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>
        >
    with $FutureModifier<List<SongEntity>>, $FutureProvider<List<SongEntity>> {
  FavoriteBasedRecommendationsProvider._({
    required FavoriteBasedRecommendationsFamily super.from,
    required ({int limit, int refreshNonce}) super.argument,
  }) : super(
         retry: null,
         name: r'favoriteBasedRecommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteBasedRecommendationsHash();

  @override
  String toString() {
    return r'favoriteBasedRecommendationsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SongEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongEntity>> create(Ref ref) {
    final argument = this.argument as ({int limit, int refreshNonce});
    return favoriteBasedRecommendations(
      ref,
      limit: argument.limit,
      refreshNonce: argument.refreshNonce,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteBasedRecommendationsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteBasedRecommendationsHash() =>
    r'e07e7497cabe0b64db6171bb5f3544358cd538ed';

final class FavoriteBasedRecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SongEntity>>,
          ({int limit, int refreshNonce})
        > {
  FavoriteBasedRecommendationsFamily._()
    : super(
        retry: null,
        name: r'favoriteBasedRecommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FavoriteBasedRecommendationsProvider call({
    int limit = 30,
    int refreshNonce = 0,
  }) => FavoriteBasedRecommendationsProvider._(
    argument: (limit: limit, refreshNonce: refreshNonce),
    from: this,
  );

  @override
  String toString() => r'favoriteBasedRecommendationsProvider';
}

@ProviderFor(playlistBasedRecommendations)
final playlistBasedRecommendationsProvider =
    PlaylistBasedRecommendationsFamily._();

final class PlaylistBasedRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SongEntity>>,
          List<SongEntity>,
          FutureOr<List<SongEntity>>
        >
    with $FutureModifier<List<SongEntity>>, $FutureProvider<List<SongEntity>> {
  PlaylistBasedRecommendationsProvider._({
    required PlaylistBasedRecommendationsFamily super.from,
    required ({int limit, int refreshNonce}) super.argument,
  }) : super(
         retry: null,
         name: r'playlistBasedRecommendationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistBasedRecommendationsHash();

  @override
  String toString() {
    return r'playlistBasedRecommendationsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SongEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SongEntity>> create(Ref ref) {
    final argument = this.argument as ({int limit, int refreshNonce});
    return playlistBasedRecommendations(
      ref,
      limit: argument.limit,
      refreshNonce: argument.refreshNonce,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistBasedRecommendationsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistBasedRecommendationsHash() =>
    r'4e2e04f99b66750a6f0cfb56c5829768d155e969';

final class PlaylistBasedRecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SongEntity>>,
          ({int limit, int refreshNonce})
        > {
  PlaylistBasedRecommendationsFamily._()
    : super(
        retry: null,
        name: r'playlistBasedRecommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistBasedRecommendationsProvider call({
    int limit = 30,
    int refreshNonce = 0,
  }) => PlaylistBasedRecommendationsProvider._(
    argument: (limit: limit, refreshNonce: refreshNonce),
    from: this,
  );

  @override
  String toString() => r'playlistBasedRecommendationsProvider';
}
