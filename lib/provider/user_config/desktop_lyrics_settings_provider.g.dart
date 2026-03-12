// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_lyrics_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DesktopLyricsSettings)
final desktopLyricsSettingsProvider = DesktopLyricsSettingsProvider._();

final class DesktopLyricsSettingsProvider
    extends $AsyncNotifierProvider<DesktopLyricsSettings, DesktopLyricsConfig> {
  DesktopLyricsSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopLyricsSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopLyricsSettingsHash();

  @$internal
  @override
  DesktopLyricsSettings create() => DesktopLyricsSettings();
}

String _$desktopLyricsSettingsHash() =>
    r'3e0379baed06bbc162953c1edfe9bdcd982b6415';

abstract class _$DesktopLyricsSettings
    extends $AsyncNotifier<DesktopLyricsConfig> {
  FutureOr<DesktopLyricsConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DesktopLyricsConfig>, DesktopLyricsConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DesktopLyricsConfig>, DesktopLyricsConfig>,
              AsyncValue<DesktopLyricsConfig>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
