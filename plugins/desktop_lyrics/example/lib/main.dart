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

  bool _enabled = true;
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
    _pushConfig();
  }

  Future<void> _pushConfig() async {
    await _lyrics.configure(
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
    await _lyrics.show();
    const text = 'Desktop Lyrics live preview';
    for (var i = 1; i <= text.length; i++) {
      if (!mounted) return;
      await _lyrics.render(
        DesktopLyricsFrame.fromTimedTokens(
          lineProgress: i / text.length,
          tokens: [
            DesktopLyricsTokenTiming(text: text.substring(0, i), durationMs: 1),
          ],
        ),
      );
      await Future.delayed(const Duration(milliseconds: 40));
    }
    if (mounted) setState(() => _playingLineDemo = false);
  }

  Future<void> _playTokenDemo() async {
    if (_playingTokenDemo) return;
    setState(() => _playingTokenDemo = true);
    await _lyrics.show();
    for (var i = 0; i <= 20; i++) {
      if (!mounted) return;
      final lineProgress = i / 20.0;
      final a = (lineProgress * 1.4).clamp(0.0, 1.0);
      final b = ((lineProgress - 0.3) * 1.5).clamp(0.0, 1.0);
      final c = ((lineProgress - 0.65) * 2.2).clamp(0.0, 1.0);
      await _lyrics.render(
        DesktopLyricsFrame.tokenized(
          tokens: [
            DesktopLyricsToken(text: 'Hello ', progress: a),
            DesktopLyricsToken(text: 'desktop ', progress: b),
            DesktopLyricsToken(text: 'lyrics', progress: c),
          ],
        ),
      );
      await Future.delayed(const Duration(milliseconds: 40));
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
                onPressed: () => _lyrics.show(),
                child: const Text('Show'),
              ),
              FilledButton(
                onPressed: () => _lyrics.hide(),
                child: const Text('Hide'),
              ),
              FilledButton(
                onPressed: _pushConfig,
                child: const Text('Apply Config'),
              ),
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
                        DropdownMenuItem(value: TextAlign.start, child: Text('Start')),
                        DropdownMenuItem(value: TextAlign.center, child: Text('Center')),
                        DropdownMenuItem(value: TextAlign.end, child: Text('End')),
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
                        DropdownMenuItem(value: FontWeight.w300, child: Text('w300')),
                        DropdownMenuItem(value: FontWeight.w400, child: Text('w400')),
                        DropdownMenuItem(value: FontWeight.w500, child: Text('w500')),
                        DropdownMenuItem(value: FontWeight.w600, child: Text('w600')),
                        DropdownMenuItem(value: FontWeight.w700, child: Text('w700')),
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
        SizedBox(width: 170, child: Text('$label (${value.toStringAsFixed(2)})')),
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
