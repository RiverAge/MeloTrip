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
    extends
        $AsyncNotifierProvider<Favorite, Result<SubsonicResponse, AppFailure>> {
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

String _$favoriteHash() => r'fc0d40897f0c1acc9de597bd5a8e7b584fd545b6';

abstract class _$Favorite
    extends $AsyncNotifier<Result<SubsonicResponse, AppFailure>> {
  FutureOr<Result<SubsonicResponse, AppFailure>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<SubsonicResponse, AppFailure>>,
              Result<SubsonicResponse, AppFailure>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<SubsonicResponse, AppFailure>>,
                Result<SubsonicResponse, AppFailure>
              >,
              AsyncValue<Result<SubsonicResponse, AppFailure>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
