import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/lyrics_settings.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';

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
  static DesktopLyricsConfig currentValue = _testDesktopLyricsConfig;

  static DesktopLyricsConfig? lastUpdatedConfig;

  @override
  Future<DesktopLyricsConfig> build() async => currentValue;

  @override
  Future<void> updateConfig(DesktopLyricsConfig config) async {
    currentValue = config;
    lastUpdatedConfig = config;
    state = AsyncData(config);
  }
}

void main() {
  tearDown(() {
    _FakeDesktopLyricsSettings.currentValue = _testDesktopLyricsConfig;
    _FakeDesktopLyricsSettings.lastUpdatedConfig = null;
  });

  Widget buildApp(Widget child) {
    return ProviderScope(
      overrides: [
        desktopLyricsSettingsProvider.overrideWith(
          _FakeDesktopLyricsSettings.new,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('DesktopLyricsSettingsTab renders core settings sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        DesktopLyricsSettingsTab(
          onApplyConfig: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Desktop Lyrics'), findsWidgets);
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Font size'), findsOneWidget);
    expect(find.text('Stroke width'), findsOneWidget);
    expect(find.byType(Switch), findsWidgets);
    expect(find.byType(DropdownButton<TextAlign>), findsOneWidget);
    expect(find.byType(DropdownButton<FontWeight>), findsOneWidget);
  });

  testWidgets('DesktopLyricsSettingsTab updates provider when toggling enabled', (
    tester,
  ) async {
    DesktopLyricsConfig? appliedConfig;
    await tester.pumpWidget(
      buildApp(
        DesktopLyricsSettingsTab(
          onApplyConfig: (DesktopLyricsConfig config) async {
            appliedConfig = config;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(_FakeDesktopLyricsSettings.lastUpdatedConfig, isNotNull);
    expect(
      _FakeDesktopLyricsSettings.lastUpdatedConfig!.interaction.enabled,
      isTrue,
    );
    expect(appliedConfig?.interaction.enabled, isTrue);
  });

  testWidgets('DesktopLyricsSettingsTab updates text align selection', (
    tester,
  ) async {
    DesktopLyricsConfig? appliedConfig;
    await tester.pumpWidget(
      buildApp(
        DesktopLyricsSettingsTab(
          onApplyConfig: (DesktopLyricsConfig config) async {
            appliedConfig = config;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<TextAlign>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Center').last);
    await tester.pumpAndSettle();

    expect(_FakeDesktopLyricsSettings.lastUpdatedConfig, isNotNull);
    expect(
      _FakeDesktopLyricsSettings.lastUpdatedConfig!.text.textAlign,
      TextAlign.center,
    );
    expect(appliedConfig?.text.textAlign, TextAlign.center);
  });
}
