import 'dart:convert';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class _FakeUserConfig extends UserConfig {
  static Configuration? currentValue;
  static String? savedDesktopLyricsConfig;

  @override
  Future<Configuration?> build() async => currentValue;

  @override
  Future<void> setConfiguration({
    ValueUpdater<ThemeMode?>? theme,
    ValueUpdater<AppThemeSeed?>? themeSeed,
    ValueUpdater<String?>? maxRate,
    ValueUpdater<PlaylistMode?>? playlistMode,
    ValueUpdater<bool?>? shuffle,
    ValueUpdater<Locale?>? locale,
    ValueUpdater<String?>? recentSearches,
    ValueUpdater<String>? recentSearch,
    ValueUpdater<String?>? desktopLyricsConfig,
  }) async {
    savedDesktopLyricsConfig = desktopLyricsConfig?.value;
    currentValue = currentValue?.copyWith(
      desktopLyricsConfig: savedDesktopLyricsConfig,
    );
    state = AsyncData(currentValue);
  }
}

void main() {
  tearDown(() {
    _FakeUserConfig.currentValue = null;
    _FakeUserConfig.savedDesktopLyricsConfig = null;
  });

  test(
    'desktopLyricsSettingsProvider reads config from user config JSON',
    () async {
      _FakeUserConfig.currentValue = const Configuration(
        desktopLyricsConfig:
            '{"fontSize":42,"textAlign":2,"fontWeight":4,"gradientEnabled":true,"overlayWidth":760}',
      );
      final container = ProviderContainer(
        overrides: [userConfigProvider.overrideWith(_FakeUserConfig.new)],
      );
      addTearDown(container.dispose);

      final config = await container.read(desktopLyricsSettingsProvider.future);

      expect(config.text.fontSize, 42);
      expect(config.text.textAlign, TextAlign.center);
      expect(config.text.fontWeight, FontWeight.w500);
      expect(config.gradient.textGradientEnabled, isTrue);
      expect(config.layout.overlayWidth, 760);
    },
  );

  test('desktopLyricsSettingsProvider defaults text align to center', () async {
    _FakeUserConfig.currentValue = const Configuration(
      desktopLyricsConfig: '{"fontSize":42}',
    );
    final container = ProviderContainer(
      overrides: [userConfigProvider.overrideWith(_FakeUserConfig.new)],
    );
    addTearDown(container.dispose);

    final config = await container.read(desktopLyricsSettingsProvider.future);

    expect(config.text.textAlign, TextAlign.center);
  });

  test(
    'desktopLyricsSettingsProvider writes config back into user config',
    () async {
      _FakeUserConfig.currentValue = const Configuration(username: 'tester');
      final container = ProviderContainer(
        overrides: [userConfigProvider.overrideWith(_FakeUserConfig.new)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(desktopLyricsSettingsProvider.notifier);
      const next = DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: true,
          clickThrough: true,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: 40,
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w700,
        ),
        background: DesktopLyricsBackgroundConfig(opacity: 0.88),
        gradient: DesktopLyricsGradientConfig(textGradientEnabled: true),
        layout: DesktopLyricsLayoutConfig(overlayWidth: 720),
      );

      await notifier.updateConfig(next);

      expect(_FakeUserConfig.savedDesktopLyricsConfig, isNotNull);
      final savedJson =
          jsonDecode(_FakeUserConfig.savedDesktopLyricsConfig!)
              as Map<String, dynamic>;
      expect(savedJson['interactionEnabled'], isTrue);
      expect(savedJson['clickThrough'], isTrue);
      expect(savedJson['fontSize'], 40);
      expect(savedJson['textAlign'], TextAlign.end.index);
      expect(savedJson['fontWeight'], 6);
      expect(savedJson['gradientEnabled'], isTrue);
      expect(savedJson['overlayWidth'], 720);
    },
  );

  test(
    'desktopLyricsSettingsProvider persists centered align and transparent background',
    () async {
      _FakeUserConfig.currentValue = const Configuration(username: 'tester');
      final container = ProviderContainer(
        overrides: [userConfigProvider.overrideWith(_FakeUserConfig.new)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(desktopLyricsSettingsProvider.notifier);
      const next = DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: false,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: 34,
          textAlign: TextAlign.center,
        ),
        background: DesktopLyricsBackgroundConfig(
          opacity: 0.0,
          backgroundColor: Color(0x00010203),
        ),
      );

      await notifier.updateConfig(next);

      expect(_FakeUserConfig.savedDesktopLyricsConfig, isNotNull);
      final savedJson =
          jsonDecode(_FakeUserConfig.savedDesktopLyricsConfig!)
              as Map<String, dynamic>;
      expect(savedJson['textAlign'], TextAlign.center.index);
      expect(savedJson['backgroundOpacity'], 0.0);
    },
  );
}
