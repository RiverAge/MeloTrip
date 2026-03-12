part of '../desktop_lyrics.dart';

/// Complete configuration object for desktop lyrics overlay.
@immutable
class DesktopLyricsConfig {
  /// Creates full overlay configuration.
  const DesktopLyricsConfig({
    required this.interaction,
    required this.text,
    this.background = const DesktopLyricsBackgroundConfig(),
    this.gradient = const DesktopLyricsGradientConfig(),
    this.layout = const DesktopLyricsLayoutConfig(),
  });

  final DesktopLyricsInteractionConfig interaction;
  final DesktopLyricsTextConfig text;
  final DesktopLyricsBackgroundConfig background;
  final DesktopLyricsGradientConfig gradient;
  final DesktopLyricsLayoutConfig layout;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsConfig &&
          interaction == other.interaction &&
          text == other.text &&
          background == other.background &&
          gradient == other.gradient &&
          layout == other.layout;

  @override
  int get hashCode =>
      Object.hash(interaction, text, background, gradient, layout);

  /// Returns a copy with selective overrides.
  DesktopLyricsConfig copyWith({
    DesktopLyricsInteractionConfig? interaction,
    DesktopLyricsTextConfig? text,
    DesktopLyricsBackgroundConfig? background,
    DesktopLyricsGradientConfig? gradient,
    DesktopLyricsLayoutConfig? layout,
  }) {
    return DesktopLyricsConfig(
      interaction: interaction ?? this.interaction,
      text: text ?? this.text,
      background: background ?? this.background,
      gradient: gradient ?? this.gradient,
      layout: layout ?? this.layout,
    );
  }
}

/// Read-only snapshot of current runtime state.
@immutable
class DesktopLyricsStateSnapshot {
  /// Creates a state snapshot.
  const DesktopLyricsStateSnapshot({
    required this.interaction,
    required this.text,
    required this.background,
    required this.gradient,
    required this.layout,
  });

  final DesktopLyricsInteractionConfig interaction;
  final DesktopLyricsTextConfig text;
  final DesktopLyricsBackgroundConfig background;
  final DesktopLyricsGradientConfig gradient;
  final DesktopLyricsLayoutConfig layout;

  /// Converts current snapshot into a full config object.
  DesktopLyricsConfig toConfig() {
    return DesktopLyricsConfig(
      interaction: interaction,
      text: text,
      background: background,
      gradient: gradient,
      layout: layout,
    );
  }

  /// Creates a config from this snapshot with selective overrides.
  DesktopLyricsConfig copyWith({
    DesktopLyricsInteractionConfig? interaction,
    DesktopLyricsTextConfig? text,
    DesktopLyricsBackgroundConfig? background,
    DesktopLyricsGradientConfig? gradient,
    DesktopLyricsLayoutConfig? layout,
  }) {
    return toConfig().copyWith(
      interaction: interaction,
      text: text,
      background: background,
      gradient: gradient,
      layout: layout,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsStateSnapshot &&
          interaction == other.interaction &&
          text == other.text &&
          background == other.background &&
          gradient == other.gradient &&
          layout == other.layout;

  @override
  int get hashCode =>
      Object.hash(interaction, text, background, gradient, layout);
}
