// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanStatus)
final scanStatusProvider = ScanStatusProvider._();

final class ScanStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>>,
          Result<SubsonicResponse, AppFailure>,
          FutureOr<Result<SubsonicResponse, AppFailure>>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>> {
  ScanStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanStatusHash();

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>> create(Ref ref) {
    return scanStatus(ref);
  }
}

String _$scanStatusHash() => r'b0876fa5b53cbd18a70e9fd5255a0aa5a285774e';
