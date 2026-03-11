// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Favorite)
final favoriteProvider = FavoriteProvider._();

final class FavoriteProvider
    extends $AsyncNotifierProvider<Favorite, SubsonicResponse?> {
  FavoriteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteHash();

  @$internal
  @override
  Favorite create() => Favorite();
}

String _$favoriteHash() => r'fe5248ebd656f8e2bf4a15584e60a2cc7de48d84';

abstract class _$Favorite extends $AsyncNotifier<SubsonicResponse?> {
  FutureOr<SubsonicResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubsonicResponse?>, SubsonicResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubsonicResponse?>, SubsonicResponse?>,
              AsyncValue<SubsonicResponse?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
