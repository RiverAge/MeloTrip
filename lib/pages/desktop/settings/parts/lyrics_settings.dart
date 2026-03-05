import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class DesktopLyricsConfigCard extends StatelessWidget {
  const DesktopLyricsConfigCard({
    super.key,
    required this.l10n,
    required this.enabled,
    required this.clickThrough,
    required this.fontSize,
    required this.opacity,
    required this.strokeWidth,
    required this.textColor,
    required this.shadowColor,
    required this.strokeColor,
    required this.onEnabledChanged,
    required this.onClickThroughChanged,
    required this.onFontSizeChanged,
    required this.onFontSizeChangeEnd,
    required this.onOpacityChanged,
    required this.onOpacityChangeEnd,
    required this.onStrokeWidthChanged,
    required this.onStrokeWidthChangeEnd,
    required this.textAlign,
    required this.fontWeight,
    required this.onTextAlignChanged,
    required this.onFontWeightChanged,
    required this.onTextColorChanged,
    required this.onShadowColorChanged,
    required this.onStrokeColorChanged,
    required this.backgroundBaseColor,
    required this.backgroundOpacity,
    required this.onBackgroundBaseColorChanged,
    required this.onBackgroundOpacityChanged,
    required this.onBackgroundOpacityChangeEnd,
    required this.gradientEnabled,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.onGradientEnabledChanged,
    required this.onGradientStartColorChanged,
    required this.onGradientEndColorChanged,
    required this.overlayWidth,
    required this.overlayHeight,
    required this.onOverlayWidthChanged,
    required this.onOverlayWidthChangeEnd,
    required this.onOverlayHeightChanged,
    required this.onOverlayHeightChangeEnd,
    required this.simulatingLyrics,
    required this.onSimulatePressed,
    required this.simulatingTokenLyrics,
    required this.onSimulateTokenPressed,
  });

  final AppLocalizations l10n;
  final bool enabled;
  final bool clickThrough;
  final double fontSize;
  final double opacity;
  final double strokeWidth;
  final int textColor;
  final int shadowColor;
  final int strokeColor;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onClickThroughChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onFontSizeChangeEnd;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onOpacityChangeEnd;
  final ValueChanged<double> onStrokeWidthChanged;
  final ValueChanged<double> onStrokeWidthChangeEnd;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final ValueChanged<TextAlign> onTextAlignChanged;
  final ValueChanged<FontWeight> onFontWeightChanged;
  final ValueChanged<int> onTextColorChanged;
  final ValueChanged<int> onShadowColorChanged;
  final ValueChanged<int> onStrokeColorChanged;
  final int backgroundBaseColor;
  final double backgroundOpacity;
  final ValueChanged<int> onBackgroundBaseColorChanged;
  final ValueChanged<double> onBackgroundOpacityChanged;
  final ValueChanged<double> onBackgroundOpacityChangeEnd;
  final bool gradientEnabled;
  final int gradientStartColor;
  final int gradientEndColor;
  final ValueChanged<bool> onGradientEnabledChanged;
  final ValueChanged<int> onGradientStartColorChanged;
  final ValueChanged<int> onGradientEndColorChanged;
  final double overlayWidth;
  final double overlayHeight;
  final ValueChanged<double> onOverlayWidthChanged;
  final ValueChanged<double> onOverlayWidthChangeEnd;
  final ValueChanged<double> onOverlayHeightChanged;
  final ValueChanged<double> onOverlayHeightChangeEnd;
  final bool simulatingLyrics;
  final Future<void> Function() onSimulatePressed;
  final bool simulatingTokenLyrics;
  final Future<void> Function() onSimulateTokenPressed;

  @override
  Widget build(BuildContext context) {
    // Current DesktopLyricsConfigCard implementation goes here
    // For now I'll just keep it minimal or move the whole thing.
    return const Placeholder(); // Will replace with actual implementation
  }
}
