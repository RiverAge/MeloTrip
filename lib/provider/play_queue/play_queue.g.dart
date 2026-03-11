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
          AsyncValue<SubsonicResponse?>,
          SubsonicResponse?,
          FutureOr<SubsonicResponse?>
        >
    with
        $FutureModifier<SubsonicResponse?>,
        $FutureProvider<SubsonicResponse?> {
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
  $FutureProviderElement<SubsonicResponse?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubsonicResponse?> create(Ref ref) {
    return playQueue(ref);
  }
}

String _$playQueueHash() => r'9bbd8b1bd698325ad63ed3c716e57cdcbe1a9cc5';
