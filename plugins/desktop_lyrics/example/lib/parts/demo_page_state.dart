part of '../main.dart';

class _DesktopLyricsDemoPageState extends State<_DesktopLyricsDemoPage> {
  final _lyrics = DesktopLyrics();
  static const String _previewLine = 'Desktop Lyrics Enabled';
  static const String _tokenPreviewLine = 'Karaoke tokens in progress';

  bool _playingLineDemo = false;
  bool _playingTokenDemo = false;
  late DesktopLyricsConfig _currentConfig;

  static const List<int> _palette = <int>[
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
    _currentConfig = _lyrics.state.toConfig();
    _lyrics.addListener(_onLyricsStateChanged);
    Future<void>.microtask(() {
      _commit((config) {
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
    setState(() {
      _currentConfig = _lyrics.state.toConfig();
    });
  }

  Future<void> _applyToNative(DesktopLyricsConfig config) async {
    await _lyrics.apply(config);
  }

  void _preview(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) {
    final next = transform(_currentConfig);
    setState(() {
      _currentConfig = next;
    });
    unawaited(_applyToNative(next));
  }

  Future<void> _commit(
    DesktopLyricsConfig Function(DesktopLyricsConfig config) transform,
  ) async {
    final next = transform(_currentConfig);
    _currentConfig = next;
    await _applyToNative(next);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _playLineDemo() async {
    if (_playingLineDemo) {
      return;
    }
    setState(() => _playingLineDemo = true);
    try {
      await _lyrics.render(
        const DesktopLyricsFrame.line(
          currentLine: _previewLine,
          lineProgress: 0.0,
        ),
      );
      for (int i = 1; i <= 5; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 120));
        await _lyrics.render(
          DesktopLyricsFrame.line(
            currentLine: _previewLine,
            lineProgress: i / 5,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _playingLineDemo = false);
      }
    }
  }

  Future<void> _playTokenDemo() async {
    if (_playingTokenDemo) {
      return;
    }
    setState(() => _playingTokenDemo = true);
    const List<DesktopLyricsTokenTiming> tokens = <DesktopLyricsTokenTiming>[
      DesktopLyricsTokenTiming(text: 'Karaoke ', duration: Duration(milliseconds: 260)),
      DesktopLyricsTokenTiming(text: 'tokens ', duration: Duration(milliseconds: 260)),
      DesktopLyricsTokenTiming(text: 'in ', duration: Duration(milliseconds: 220)),
      DesktopLyricsTokenTiming(text: 'progress', duration: Duration(milliseconds: 320)),
    ];
    try {
      for (int i = 0; i <= 8; i++) {
        await _lyrics.render(
          DesktopLyricsFrame.fromTimedTokens(
            tokens: tokens,
            lineProgress: i / 8,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 110));
      }
      await _lyrics.render(
        const DesktopLyricsFrame.line(
          currentLine: _tokenPreviewLine,
          lineProgress: 1.0,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _playingTokenDemo = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentConfig;
    final enabled = state.interaction.enabled;
    final clickThrough = state.interaction.clickThrough;
    final gradientEnabled = state.gradient.textGradientEnabled;
    final fontSize = state.text.fontSize;
    final opacity = state.background.opacity;
    final strokeWidth = state.text.strokeWidth ?? 0.0;
    final overlayWidth = state.layout.overlayWidth ?? 980.0;
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

    return buildDemoPage(
      context: context,
      enabled: enabled,
      clickThrough: clickThrough,
      gradientEnabled: gradientEnabled,
      fontSize: fontSize,
      opacity: opacity,
      strokeWidth: strokeWidth,
      overlayWidth: overlayWidth,
      textAlign: textAlign,
      fontWeight: fontWeight,
      textColor: textColor,
      shadowColor: shadowColor,
      strokeColor: strokeColor,
      backgroundBaseColor: backgroundBaseColor,
      backgroundOpacity: backgroundOpacity,
      gradientStartColor: gradientStartColor,
      gradientEndColor: gradientEndColor,
    );
  }
}
