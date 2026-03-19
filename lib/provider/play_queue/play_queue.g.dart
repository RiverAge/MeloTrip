// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_queue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playQueue)
final playQueueProvider = PlayQueueProvider._();

final class PlayQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>>,
          Result<SubsonicResponse, AppFailure>,
          FutureOr<Result<SubsonicResponse, AppFailure>>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>> {
  PlayQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playQueueHash();

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>> create(Ref ref) {
    return playQueue(ref);
  }
}

String _$playQueueHash() => r'50bdef08a4f63bada53029d8c35a284cdd8ff1d3';
