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

  bool _enabled = false;
  bool _clickThrough = false;
  bool _gradientEnabled = true;
  double _fontSize = 34;
  double _opacity = 0.93;
  double _strokeWidth = 0;
  double _overlayWidth = 980;
  double _overlayHeight = 160;
  bool _overlayHeightCustomized = false;
  TextAlign _textAlign = TextAlign.start;
  FontWeight _fontWeight = FontWeight.w400;

  int _textColor = 0xFFF2F2F8;
  int _shadowColor = 0xFF121214;
  int _strokeColor = 0x00000000;
  int _backgroundBaseColor = 0xFF220A35;
  double _backgroundOpacity = 0x7A / 255.0;
  int _gradientStartColor = 0xFFFFD36E;
  int _gradientEndColor = 0xFFFF4D8D;

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
    // Delay native overlay initialization until user action to avoid
    // startup-time native window instability on some Windows environments.
  }

  @override
  void dispose() {
    _lyrics.dispose();
    super.dispose();
  }

  Future<void> _pushConfig() async {
    await _lyrics.applyConfig(
      DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: _enabled,
          clickThrough: _clickThrough,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: _fontSize,
          textColor: Color(_textColor),
          shadowColor: Color(_shadowColor),
          strokeColor: Color(_strokeColor),
          strokeWidth: _strokeWidth,
          fontFamily: 'Segoe UI',
          textAlign: _textAlign,
          fontWeight: _fontWeight,
        ),
        background: DesktopLyricsBackgroundConfig(
          opacity: _opacity,
          backgroundColor: Color(
            ((255 * _backgroundOpacity).round() << 24) |
                (_backgroundBaseColor & 0x00FFFFFF),
          ),
          backgroundRadius: 22,
          backgroundPadding: 12,
        ),
        gradient: DesktopLyricsGradientConfig(
          textGradientEnabled: _gradientEnabled,
          textGradientStartColor: Color(_gradientStartColor),
          textGradientEndColor: Color(_gradientEndColor),
          textGradientAngle: 0,
        ),
        layout: DesktopLyricsLayoutConfig(
          overlayWidth: _overlayWidth,
          overlayHeight: _overlayHeightCustomized ? _overlayHeight : null,
        ),
      ),
    );
  }

  Future<void> _playLineDemo() async {
    if (_playingLineDemo) return;
    setState(() => _playingLineDemo = true);
    await _lyrics.setEnabled(true);
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
    await _lyrics.setEnabled(true);
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
                  value: _enabled,
                  onChanged: (v) async {
                    setState(() => _enabled = v);
                    await _pushConfig();
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
                  value: _clickThrough,
                  onChanged: (v) async {
                    setState(() => _clickThrough = v);
                    await _pushConfig();
                  },
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
                  value: _fontSize,
                  min: 20,
                  max: 72,
                  onChanged: (v) => setState(() => _fontSize = v),
                  onChangeEnd: (_) => _pushConfig(),
                ),
                _slider(
                  label: 'Opacity',
                  value: _opacity,
                  min: .25,
                  max: 1,
                  onChanged: (v) => setState(() => _opacity = v),
                  onChangeEnd: (_) => _pushConfig(),
                ),
                _slider(
                  label: 'Stroke Width',
                  value: _strokeWidth,
                  min: 0,
                  max: 6,
                  onChanged: (v) => setState(() => _strokeWidth = v),
                  onChangeEnd: (_) => _pushConfig(),
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Text Align')),
                    DropdownButton<TextAlign>(
                      value: _textAlign,
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
                      onChanged: (v) async {
                        if (v == null) return;
                        setState(() => _textAlign = v);
                        await _pushConfig();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Font Weight')),
                    DropdownButton<FontWeight>(
                      value: _fontWeight,
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
                      onChanged: (v) async {
                        if (v == null) return;
                        setState(() => _fontWeight = v);
                        await _pushConfig();
                      },
                    ),
                  ],
                ),
                _colorRow(
                  label: 'Text Color',
                  value: _textColor,
                  onChanged: (v) async {
                    setState(() => _textColor = v);
                    await _pushConfig();
                  },
                ),
                _colorRow(
                  label: 'Shadow Color',
                  value: _shadowColor,
                  onChanged: (v) async {
                    setState(() => _shadowColor = v);
                    await _pushConfig();
                  },
                ),
                _colorRow(
                  label: 'Stroke Color',
                  value: _strokeColor,
                  onChanged: (v) async {
                    setState(() => _strokeColor = v);
                    await _pushConfig();
                  },
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
                  value: _backgroundBaseColor,
                  onChanged: (v) async {
                    setState(() => _backgroundBaseColor = v);
                    await _pushConfig();
                  },
                ),
                _slider(
                  label: 'Background Opacity',
                  value: _backgroundOpacity,
                  min: 0,
                  max: 1,
                  onChanged: (v) => setState(() => _backgroundOpacity = v),
                  onChangeEnd: (_) => _pushConfig(),
                ),
                SwitchListTile(
                  title: const Text('Text Gradient'),
                  value: _gradientEnabled,
                  onChanged: (v) async {
                    setState(() => _gradientEnabled = v);
                    await _pushConfig();
                  },
                ),
                _colorRow(
                  label: 'Gradient Start',
                  value: _gradientStartColor,
                  onChanged: (v) async {
                    setState(() => _gradientStartColor = v);
                    await _pushConfig();
                  },
                ),
                _colorRow(
                  label: 'Gradient End',
                  value: _gradientEndColor,
                  onChanged: (v) async {
                    setState(() => _gradientEndColor = v);
                    await _pushConfig();
                  },
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
                  value: _overlayWidth,
                  min: 480,
                  max: 1800,
                  onChanged: (v) => setState(() => _overlayWidth = v),
                  onChangeEnd: (_) => _pushConfig(),
                ),
                SwitchListTile(
                  title: const Text('Custom Overlay Height'),
                  value: _overlayHeightCustomized,
                  onChanged: (v) async {
                    setState(() => _overlayHeightCustomized = v);
                    await _pushConfig();
                  },
                ),
                _slider(
                  label: 'Overlay Height',
                  value: _overlayHeight,
                  min: 90,
                  max: 400,
                  onChanged: (v) => setState(() => _overlayHeight = v),
                  onChangeEnd: (_) => _pushConfig(),
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
    required ValueChanged<double> onChangeEnd,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 170,
          child: Text('$label (${value.toStringAsFixed(2)})'),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }

  Widget _colorRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
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
                        color: active ? Colors.black : Colors.black26,
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
