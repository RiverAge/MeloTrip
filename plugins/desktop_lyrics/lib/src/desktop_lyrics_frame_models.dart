part of '../desktop_lyrics.dart';

/// A token segment for karaoke-style lyric rendering.
///
/// [text] is the token content and [progress] is its local highlight progress
/// in range `0.0..1.0`.
@immutable
class DesktopLyricsToken {
  /// Creates a token segment with text and local progress.
  const DesktopLyricsToken({required this.text, required this.progress});

  final String text;
  final double progress;
}

/// A token with a relative duration used to build karaoke frames.
@immutable
class DesktopLyricsTokenTiming {
  /// Creates a timed token.
  const DesktopLyricsTokenTiming({required this.text, required this.duration});

  final String text;
  final Duration duration;
}

/// A token with absolute time range used to build karaoke frames.
@immutable
class DesktopLyricsTimelineToken {
  /// Creates a timeline token.
  const DesktopLyricsTimelineToken({
    required this.text,
    required this.start,
    required this.end,
  });

  final String text;
  final Duration start;
  final Duration end;
}

/// A render frame consumed by the desktop lyrics overlay.
@immutable
class DesktopLyricsFrame {
  /// Builds a static line frame.
  ///
  /// [lineProgress] defaults to `1.0` to keep text fully visible.
  // `.line` is for static single-line display by default, so progress defaults
  // to fully visible. Callers can pass a custom value when they need sweeping.
  const DesktopLyricsFrame.line({
    required this.currentLine,
    this.lineProgress = 1.0,
  }) : tokens = const [];

  /// Builds a tokenized frame for karaoke rendering.
  ///
  /// If [resolvedLine] is omitted, line text is derived from [tokens].
  const DesktopLyricsFrame.tokenized({
    required this.tokens,
    this.lineProgress,
    String? resolvedLine,
  }) : currentLine = resolvedLine ?? '';

  final String currentLine;
  final double? lineProgress;
  final List<DesktopLyricsToken> tokens;

  /// Returns the effective line text for native rendering.
  String get effectiveLine =>
      tokens.isNotEmpty ? tokens.map((e) => e.text).join() : currentLine;

  /// Creates a frame from relative token durations.
  factory DesktopLyricsFrame.fromTimedTokens({
    required List<DesktopLyricsTokenTiming> tokens,
    required double lineProgress,
  }) {
    final normalized = lineProgress.clamp(0.0, 1.0);
    if (tokens.isEmpty) {
      return DesktopLyricsFrame.line(currentLine: '', lineProgress: normalized);
    }
    var total = 0;
    for (final token in tokens) {
      final ms = token.duration.inMilliseconds;
      total += ms > 0 ? ms : 1;
    }
    var elapsed = 0;
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final ms = token.duration.inMilliseconds;
      final duration = ms > 0 ? ms : 1;
      final start = elapsed / total;
      final end = (elapsed + duration) / total;
      final local = ((normalized - start) / (end - start)).clamp(0.0, 1.0);
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
      elapsed += duration;
    }
    return DesktopLyricsFrame.tokenized(
      resolvedLine: tokens.map((e) => e.text).join(),
      lineProgress: normalized,
      tokens: mapped,
    );
  }

  /// Creates a frame from absolute timeline tokens and current playback [position].
  factory DesktopLyricsFrame.fromKaraokeTimeline({
    required Duration position,
    required List<DesktopLyricsTimelineToken> tokens,
  }) {
    if (tokens.isEmpty) {
      return const DesktopLyricsFrame.line(currentLine: '', lineProgress: 1.0);
    }
    final positionMs = position.inMilliseconds;
    final minStart = tokens.first.start.inMilliseconds;
    final maxEnd = tokens.last.end.inMilliseconds;
    final total = (maxEnd - minStart).clamp(1, 1 << 30);
    final normalized =
        ((positionMs - minStart) / total).clamp(0.0, 1.0).toDouble();
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final tokenStart = token.start.inMilliseconds;
      final tokenEnd = token.end.inMilliseconds;
      final denom = (tokenEnd - tokenStart).clamp(1, 1 << 30);
      final local =
          ((positionMs - tokenStart) / denom).clamp(0.0, 1.0).toDouble();
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
    }
    return DesktopLyricsFrame.tokenized(
      resolvedLine: tokens.map((e) => e.text).join(),
      lineProgress: normalized,
      tokens: mapped,
    );
  }
}
