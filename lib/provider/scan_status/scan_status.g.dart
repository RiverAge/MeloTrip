// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanStatusResult)
final scanStatusResultProvider = ScanStatusResultProvider._();

final class ScanStatusResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SubsonicResponse, AppFailure>>,
          Result<SubsonicResponse, AppFailure>,
          FutureOr<Result<SubsonicResponse, AppFailure>>
        >
    with
        $FutureModifier<Result<SubsonicResponse, AppFailure>>,
        $FutureProvider<Result<SubsonicResponse, AppFailure>> {
  ScanStatusResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanStatusResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanStatusResultHash();

  @$internal
  @override
  $FutureProviderElement<Result<SubsonicResponse, AppFailure>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SubsonicResponse, AppFailure>> create(Ref ref) {
    return scanStatusResult(ref);
  }
}

String _$scanStatusResultHash() => r'207a6e726b41883f42b552e68718f20d7a3616b0';
