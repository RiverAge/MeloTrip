part of '../desktop_lyrics.dart';

/// Interaction options for the overlay window.
@immutable
class DesktopLyricsInteractionConfig {
  /// Creates interaction configuration.
  const DesktopLyricsInteractionConfig({
    required this.enabled,
    required this.clickThrough,
  });

  final bool enabled;
  final bool clickThrough;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsInteractionConfig &&
          enabled == other.enabled &&
          clickThrough == other.clickThrough;

  @override
  int get hashCode => Object.hash(enabled, clickThrough);

  /// Returns a copy with selective overrides.
  DesktopLyricsInteractionConfig copyWith({
    bool? enabled,
    bool? clickThrough,
  }) {
    return DesktopLyricsInteractionConfig(
      enabled: enabled ?? this.enabled,
      clickThrough: clickThrough ?? this.clickThrough,
    );
  }
}

/// Text style configuration for lyrics content.
@immutable
class DesktopLyricsTextConfig {
  /// Creates text style configuration.
  const DesktopLyricsTextConfig({
    required this.fontSize,
    this.textColor,
    this.shadowColor,
    this.strokeColor,
    this.strokeWidth,
    this.fontFamily,
    this.textAlign,
    this.fontWeight,
  });

  final double fontSize;
  final Color? textColor;
  final Color? shadowColor;
  final Color? strokeColor;
  final double? strokeWidth;
  final String? fontFamily;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsTextConfig &&
          fontSize == other.fontSize &&
          textColor == other.textColor &&
          shadowColor == other.shadowColor &&
          strokeColor == other.strokeColor &&
          strokeWidth == other.strokeWidth &&
          fontFamily == other.fontFamily &&
          textAlign == other.textAlign &&
          fontWeight == other.fontWeight;

  @override
  int get hashCode => Object.hash(
        fontSize,
        textColor,
        shadowColor,
        strokeColor,
        strokeWidth,
        fontFamily,
        textAlign,
        fontWeight,
      );

  /// Returns a copy with selective overrides.
  DesktopLyricsTextConfig copyWith({
    double? fontSize,
    Color? textColor,
    Color? shadowColor,
    Color? strokeColor,
    double? strokeWidth,
    String? fontFamily,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return DesktopLyricsTextConfig(
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      shadowColor: shadowColor ?? this.shadowColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}

/// Background style configuration for the overlay panel.
@immutable
class DesktopLyricsBackgroundConfig {
  /// Creates background style configuration.
  const DesktopLyricsBackgroundConfig({
    this.opacity = 0.96,
    this.backgroundColor,
    this.backgroundRadius = 16.0,
    this.backgroundPadding = 10.0,
  });

  final double opacity;
  final Color? backgroundColor;
  final double backgroundRadius;
  final double backgroundPadding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsBackgroundConfig &&
          opacity == other.opacity &&
          backgroundColor == other.backgroundColor &&
          backgroundRadius == other.backgroundRadius &&
          backgroundPadding == other.backgroundPadding;

  @override
  int get hashCode => Object.hash(
        opacity,
        backgroundColor,
        backgroundRadius,
        backgroundPadding,
      );

  /// Returns a copy with selective overrides.
  DesktopLyricsBackgroundConfig copyWith({
    double? opacity,
    Color? backgroundColor,
    double? backgroundRadius,
    double? backgroundPadding,
  }) {
    return DesktopLyricsBackgroundConfig(
      opacity: opacity ?? this.opacity,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundRadius: backgroundRadius ?? this.backgroundRadius,
      backgroundPadding: backgroundPadding ?? this.backgroundPadding,
    );
  }
}

/// Gradient configuration for lyric text fill.
@immutable
class DesktopLyricsGradientConfig {
  /// Creates gradient style configuration.
  const DesktopLyricsGradientConfig({
    this.textGradientEnabled = false,
    this.textGradientStartColor,
    this.textGradientEndColor,
    this.textGradientAngle = 0.0,
  });

  final bool textGradientEnabled;
  final Color? textGradientStartColor;
  final Color? textGradientEndColor;
  final double textGradientAngle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsGradientConfig &&
          textGradientEnabled == other.textGradientEnabled &&
          textGradientStartColor == other.textGradientStartColor &&
          textGradientEndColor == other.textGradientEndColor &&
          textGradientAngle == other.textGradientAngle;

  @override
  int get hashCode => Object.hash(
        textGradientEnabled,
        textGradientStartColor,
        textGradientEndColor,
        textGradientAngle,
      );

  /// Returns a copy with selective overrides.
  DesktopLyricsGradientConfig copyWith({
    bool? textGradientEnabled,
    Color? textGradientStartColor,
    Color? textGradientEndColor,
    double? textGradientAngle,
  }) {
    return DesktopLyricsGradientConfig(
      textGradientEnabled: textGradientEnabled ?? this.textGradientEnabled,
      textGradientStartColor:
          textGradientStartColor ?? this.textGradientStartColor,
      textGradientEndColor: textGradientEndColor ?? this.textGradientEndColor,
      textGradientAngle: textGradientAngle ?? this.textGradientAngle,
    );
  }
}

/// Layout configuration for the overlay window.
@immutable
class DesktopLyricsLayoutConfig {
  /// Creates layout configuration.
  const DesktopLyricsLayoutConfig({this.overlayWidth});

  final double? overlayWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsLayoutConfig && overlayWidth == other.overlayWidth;

  @override
  int get hashCode => overlayWidth.hashCode;

  /// Returns a copy with selective overrides.
  DesktopLyricsLayoutConfig copyWith({
    double? overlayWidth,
  }) {
    return DesktopLyricsLayoutConfig(
      overlayWidth: overlayWidth ?? this.overlayWidth,
    );
  }
}
