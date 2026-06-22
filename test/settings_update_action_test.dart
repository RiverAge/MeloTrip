import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/pages/mobile/settings/settings_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/provider/update/update_flow.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/update/app_update_service.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('desktop settings hides update action while updating', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
          desktopLyricsSettingsProvider.overrideWith(
            _FakeDesktopLyricsSettings.new,
          ),
          updateFlowControllerProvider.overrideWithValue(_updatingState),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Update Now'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('mobile settings hides update action while updating', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedFileSizeProvider.overrideWith((_) async => 0),
          scanStatusProvider.overrideWith((_) async => _scanStatusResult),
          updateFlowControllerProvider.overrideWithValue(_updatingState),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Update Now'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}

const AppUpdateInfo _availableUpdate = AppUpdateInfo(
  versionName: '1.0.14',
  versionCode: 2014,
  sha256: '',
  fileSize: 1024,
  downloadUrl: 'https://example.com/app-release.apk',
  changelog: '',
);

const UpdateFlowState _updatingState = UpdateFlowState(
  hasChecked: true,
  isUpdating: true,
  stage: UpdateUiStage.downloading,
  availableUpdate: _availableUpdate,
  currentVersionName: '1.0.12',
  currentVersionCode: 2013,
);

const Result<SubsonicResponse, AppFailure> _scanStatusResult = Result.ok(
  SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      version: '1.2.3',
      scanStatus: ScanStatusEntity(scanning: false, count: 0),
    ),
  ),
);

const DesktopLyricsConfig _testDesktopLyricsConfig = DesktopLyricsConfig(
  interaction: DesktopLyricsInteractionConfig(
    enabled: false,
    clickThrough: false,
  ),
  text: DesktopLyricsTextConfig(fontSize: 34),
  background: DesktopLyricsBackgroundConfig(opacity: 0.93),
  gradient: DesktopLyricsGradientConfig(),
  layout: DesktopLyricsLayoutConfig(overlayWidth: 980),
);

class _FakeDesktopLyricsSettings extends DesktopLyricsSettings {
  @override
  Future<DesktopLyricsConfig> build() async => _testDesktopLyricsConfig;
}
