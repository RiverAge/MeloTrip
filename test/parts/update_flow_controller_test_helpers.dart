part of '../update_flow_controller_test.dart';

class _FakeUpdateService extends AppUpdateService {
  _FakeUpdateService({
    this.checkResult,
    this.installSupported = true,
    this.canInstallPermission = true,
    this.requiresHostExit = false,
    this.downloadError,
    this.downloadDelay = Duration.zero,
    this.checkError,
  }) : super(checkUrl: 'https://example.com/check');

  final AppUpdateCheckResult? checkResult;
  final bool installSupported;
  final bool canInstallPermission;
  final bool requiresHostExit;
  final Object? downloadError;
  final Duration downloadDelay;
  final Object? checkError;

  bool openInstallSettingsCalled = false;
  bool installCalled = false;
  WindowsUpdaterStrings? receivedUpdaterStrings;

  @override
  bool get isInstallSupported => installSupported;

  @override
  bool get requiresHostExitForInstall => requiresHostExit;

  @override
  Future<bool> canRequestInstallPermission() async => canInstallPermission;

  @override
  Future<void> openInstallPermissionSettings() async {
    openInstallSettingsCalled = true;
  }

  @override
  Future<AppUpdateCheckResult> checkForUpdate() async {
    if (checkError != null) {
      throw checkError!;
    }
    if (checkResult == null) {
      throw StateError('no result');
    }
    return checkResult!;
  }

  @override
  Future<File> downloadAndVerifyPackage({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) async {
    if (downloadDelay > Duration.zero) {
      await Future<void>.delayed(downloadDelay);
    }
    if (downloadError != null) {
      throw downloadError!;
    }
    onStageChanged?.call(UpdateDownloadStage.downloading);
    onProgress?.call(update.fileSize ~/ 2, update.fileSize, 0.5);
    onStageChanged?.call(UpdateDownloadStage.verifying);

    final Directory dir = await Directory.systemTemp.createTemp(
      'melo-trip-test',
    );
    final File file = File('${dir.path}/app.zip');
    await file.writeAsBytes(<int>[1, 2, 3, 4]);
    return file;
  }

  @override
  Future<void> installDownloadedPackage(
    File file, {
    WindowsUpdaterStrings? updaterStrings,
  }) async {
    installCalled = true;
    receivedUpdaterStrings = updaterStrings;
  }
}

ProviderContainer _createContainer(_FakeUpdateService service) {
  final ProviderContainer container = ProviderContainer(
    overrides: [appUpdateServiceProvider.overrideWith((Ref _) => service)],
  );
  addTearDown(container.dispose);
  return container;
}
