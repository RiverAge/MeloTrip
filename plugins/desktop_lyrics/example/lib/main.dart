import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4A78F0),
        useMaterial3: true,
      ),
      home: const _DesktopLyricsDemoPage(),
    );
  }
}

class _DesktopLyricsDemoPage extends StatefulWidget {
  const _DesktopLyricsDemoPage();

  @override
  State<_DesktopLyricsDemoPage> createState() => _DesktopLyricsDemoPageState();
}

class _DesktopLyricsDemoPageState extends State<_DesktopLyricsDemoPage> {
  final _lyrics = DesktopLyrics();
  static const _previewLine = 'Desktop Lyrics Enabled';

  bool _playingLineDemo = false;
  bool _playingTokenDemo = false;

  static const _palette = <int>[
    0xFFF2F2F8,
    0xFF121214,
    0xFFFFFFFF,
    0xFFFFD36E,
    0xFFFF4D8D,
    0xFF8CD867,
    0xFF4A78F0,
    0xFF220A35,
    0x00000000,
  ];

  @override
  void initState() {
    super.initState();
    _lyrics.addListener(_onLyricsStateChanged);
    Future<void>.microtask(() {
      _apply((config) {
        return config.copyWith(
          text: config.text.copyWith(fontSize: 34),
          background: config.background.copyWith(opacity: 0.93),
          layout: config.layout.copyWith(overlayWidth: 980),
        );
      });
    });
  }

  @override
  void dispose() {
    _lyrics.removeListener(_onLyricsStateChanged);
    _lyrics.dispose();
    super.dispose();
  }

  void _onLyricsStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _apply(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) async {
    final current = _lyrics.state.toConfig();
    final next = transform(current);
    await _lyrics.apply(next);
  }

  Future<void> _playLineDemo() async {
    if (_playingLineDemo) return;
    setState(() => _playingLineDemo = true);
    await _apply(
      (config) => config.copyWith(
        interaction: config.interaction.copyWith(enabled: true),
      ),
    );
    final stamp = DateTime.now().second.toString().padLeft(2, '0');
    final text = 'Desktop Lyrics live preview $stamp';
    const steps = 28;
    for (var i = 0; i <= steps; i++) {
      if (!mounted) return;
      await _lyrics.render(
        DesktopLyricsFrame.line(currentLine: text, lineProgress: i / steps),
      );
      await Future.delayed(const Duration(milliseconds: 40));
    }
    if (mounted) setState(() => _playingLineDemo = false);
  }

  Future<void> _playTokenDemo() async {
    if (_playingTokenDemo) return;
    setState(() => _playingTokenDemo = true);
    await _apply(
      (config) => config.copyWith(
        interaction: config.interaction.copyWith(enabled: true),
      ),
    );
    final stamp = DateTime.now().second.toString().padLeft(2, '0');
    final timedTokens = <DesktopLyricsTokenTiming>[
      const DesktopLyricsTokenTiming(
        text: 'Desktop ',
        duration: Duration(milliseconds: 5000),
      ),
      const DesktopLyricsTokenTiming(
        text: 'Hi ',
        duration: Duration(milliseconds: 400),
      ),
      const DesktopLyricsTokenTiming(
        text: 'lyrics ',
        duration: Duration(milliseconds: 1200),
      ),
      DesktopLyricsTokenTiming(
        text: stamp,
        duration: const Duration(milliseconds: 500),
      ),
    ];
    var totalDurationMs = 0;
    for (final token in timedTokens) {
      totalDurationMs += token.duration.inMilliseconds;
    }
    final total = totalDurationMs.clamp(1, 1 << 30);
    final segmentCount = timedTokens.length.clamp(1, 1 << 30);
    const tickMs = 40;
    for (var elapsedMs = 0; elapsedMs <= total; elapsedMs += tickMs) {
      if (!mounted) return;
      var consumedDuration = 0;
      var mappedProgress = 0.0;
      for (var idx = 0; idx < timedTokens.length; idx++) {
        final token = timedTokens[idx];
        final tokenMs = token.duration.inMilliseconds;
        final nextDuration = consumedDuration + tokenMs;
        if (elapsedMs >= nextDuration) {
          consumedDuration = nextDuration;
          mappedProgress = (idx + 1) / segmentCount;
          continue;
        }

        final safeTokenMs = tokenMs <= 0 ? 1 : tokenMs;
        final local = ((elapsedMs - consumedDuration) / safeTokenMs).clamp(
          0.0,
          1.0,
        );
        mappedProgress = ((idx + local) / segmentCount).clamp(0.0, 1.0);
        break;
      }
      await _lyrics.render(
        DesktopLyricsFrame.fromTimedTokens(
          tokens: timedTokens,
          lineProgress: mappedProgress,
        ),
      );
      await Future.delayed(const Duration(milliseconds: tickMs));
    }
    if (mounted) setState(() => _playingTokenDemo = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = _lyrics.state;
    final enabled = state.interaction.enabled;
    final clickThrough = state.interaction.clickThrough;
    final gradientEnabled = state.gradient.textGradientEnabled;
    final fontSize = state.text.fontSize;
    final opacity = state.background.opacity;
    final strokeWidth = state.text.strokeWidth ?? 0.0;
    final overlayWidth = state.layout.overlayWidth ?? 980.0;
    final overlayHeight = state.layout.overlayHeight ?? 160.0;
    final overlayHeightCustomized = state.layout.overlayHeight != null;
    final textAlign = state.text.textAlign ?? TextAlign.start;
    final fontWeight = state.text.fontWeight ?? FontWeight.w400;
    final textColor = state.text.textColor?.toARGB32() ?? 0xFFF2F2F8;
    final shadowColor = state.text.shadowColor?.toARGB32() ?? 0xFF121214;
    final strokeColor = state.text.strokeColor?.toARGB32() ?? 0x00000000;
    final backgroundColor =
        state.background.backgroundColor?.toARGB32() ?? 0x7A220A35;
    final backgroundBaseColor = 0xFF000000 | (backgroundColor & 0x00FFFFFF);
    final backgroundOpacity = ((backgroundColor >> 24) & 0xFF) / 255.0;
    final gradientStartColor =
        state.gradient.textGradientStartColor?.toARGB32() ?? 0xFFFFD36E;
    final gradientEndColor =
        state.gradient.textGradientEndColor?.toARGB32() ?? 0xFFFF4D8D;

    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Lyrics Full Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: _playingLineDemo ? null : _playLineDemo,
                child: const Text('Play Line Preview'),
              ),
              FilledButton(
                onPressed: _playingTokenDemo ? null : _playTokenDemo,
                child: const Text('Play Token Preview'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _section(
            title: 'Interaction',
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enabled'),
                  value: enabled,
                  onChanged: (v) async {
                    await _apply(
                      (config) => config.copyWith(
                        interaction: config.interaction.copyWith(enabled: v),
                      ),
                    );
                    if (v) {
                      await _lyrics.render(
                        const DesktopLyricsFrame.line(
                          currentLine: _previewLine,
                          lineProgress: 1.0,
                        ),
                      );
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('Click Through'),
                  value: clickThrough,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      interaction: config.interaction.copyWith(clickThrough: v),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Text',
            child: Column(
              children: [
                _slider(
                  label: 'Font Size',
                  value: fontSize,
                  min: 20,
                  max: 72,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      text: config.text.copyWith(fontSize: v),
                    ),
                  ),
                ),
                _slider(
                  label: 'Opacity',
                  value: opacity,
                  min: .25,
                  max: 1,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      background: config.background.copyWith(opacity: v),
                    ),
                  ),
                ),
                _slider(
                  label: 'Stroke Width',
                  value: strokeWidth,
                  min: 0,
                  max: 6,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      text: config.text.copyWith(strokeWidth: v),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Text Align')),
                    DropdownButton<TextAlign>(
                      value: textAlign,
                      items: const [
                        DropdownMenuItem(
                          value: TextAlign.start,
                          child: Text('Start'),
                        ),
                        DropdownMenuItem(
                          value: TextAlign.center,
                          child: Text('Center'),
                        ),
                        DropdownMenuItem(
                          value: TextAlign.end,
                          child: Text('End'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        unawaited(
                          _apply(
                            (config) => config.copyWith(
                              text: config.text.copyWith(textAlign: v),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Font Weight')),
                    DropdownButton<FontWeight>(
                      value: fontWeight,
                      items: const [
                        DropdownMenuItem(
                          value: FontWeight.w300,
                          child: Text('w300'),
                        ),
                        DropdownMenuItem(
                          value: FontWeight.w400,
                          child: Text('w400'),
                        ),
                        DropdownMenuItem(
                          value: FontWeight.w500,
                          child: Text('w500'),
                        ),
                        DropdownMenuItem(
                          value: FontWeight.w600,
                          child: Text('w600'),
                        ),
                        DropdownMenuItem(
                          value: FontWeight.w700,
                          child: Text('w700'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        unawaited(
                          _apply(
                            (config) => config.copyWith(
                              text: config.text.copyWith(fontWeight: v),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _colorRow(
                  label: 'Text Color',
                  value: textColor,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      text: config.text.copyWith(textColor: Color(v)),
                    ),
                  ),
                ),
                _colorRow(
                  label: 'Shadow Color',
                  value: shadowColor,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      text: config.text.copyWith(shadowColor: Color(v)),
                    ),
                  ),
                ),
                _colorRow(
                  label: 'Stroke Color',
                  value: strokeColor,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      text: config.text.copyWith(strokeColor: Color(v)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Background & Gradient',
            child: Column(
              children: [
                _colorRow(
                  label: 'Background Base',
                  value: backgroundBaseColor,
                  onChanged: (v) => _apply((config) {
                    final a =
                        ((config.background.backgroundColor?.toARGB32() ??
                                0x7A220A35) >>
                            24) &
                        0xFF;
                    final bg = (a << 24) | (v & 0x00FFFFFF);
                    return config.copyWith(
                      background: config.background.copyWith(
                        backgroundColor: Color(bg),
                      ),
                    );
                  }),
                ),
                _slider(
                  label: 'Background Opacity',
                  value: backgroundOpacity,
                  min: 0,
                  max: 1,
                  onChanged: (v) => _apply((config) {
                    final rgb =
                        (config.background.backgroundColor?.toARGB32() ??
                            0x7A220A35) &
                        0x00FFFFFF;
                    final bg = ((255 * v).round() << 24) | rgb;
                    return config.copyWith(
                      background: config.background.copyWith(
                        backgroundColor: Color(bg),
                      ),
                    );
                  }),
                ),
                SwitchListTile(
                  title: const Text('Text Gradient'),
                  value: gradientEnabled,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      gradient: config.gradient.copyWith(
                        textGradientEnabled: v,
                      ),
                    ),
                  ),
                ),
                _colorRow(
                  label: 'Gradient Start',
                  value: gradientStartColor,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      gradient: config.gradient.copyWith(
                        textGradientStartColor: Color(v),
                      ),
                    ),
                  ),
                ),
                _colorRow(
                  label: 'Gradient End',
                  value: gradientEndColor,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      gradient: config.gradient.copyWith(
                        textGradientEndColor: Color(v),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Layout',
            child: Column(
              children: [
                _slider(
                  label: 'Overlay Width',
                  value: overlayWidth,
                  min: 480,
                  max: 1800,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      layout: config.layout.copyWith(overlayWidth: v),
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Custom Overlay Height'),
                  value: overlayHeightCustomized,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      layout: config.layout.copyWith(
                        overlayHeight: v
                            ? (config.layout.overlayHeight ?? 160.0)
                            : null,
                      ),
                    ),
                  ),
                ),
                _slider(
                  label: 'Overlay Height',
                  value: overlayHeight,
                  min: 90,
                  max: 400,
                  onChanged: (v) => _apply(
                    (config) => config.copyWith(
                      layout: config.layout.copyWith(overlayHeight: v),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 170,
          child: Text('$label (${value.toStringAsFixed(2)})'),
        ),
        Expanded(
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _colorRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 170, child: Text(label)),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _palette.map((color) {
                final active = color == value;
                return InkWell(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(color),
                      border: Border.all(
                        color: active
                            ? colorScheme.onSurface
                            : colorScheme.outline.withValues(alpha: 0.5),
                        width: active ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
