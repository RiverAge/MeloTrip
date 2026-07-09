import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app/player.dart';

class AnimatedLyricsPanel extends ConsumerStatefulWidget {
  const AnimatedLyricsPanel({
    super.key,
    required this.lyricsLines,
    this.cueLinesByStart,
    this.textAlign = .center,
    this.crossAxisAlignment = .center,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.primaryFontSize = 20,
    this.secondaryFontSize = 14,
    this.blurFactor = 2,
    this.activeScaleDelta = 0.15,
    this.firstScrollAlignment = 0.5,
    this.activeScrollAlignment = 0.5,
    this.activeAnimationDuration = const Duration(milliseconds: 650),
    this.itemAnimationDuration = const Duration(milliseconds: 500),
    this.edgeFadeTopStop = 0.1,
    this.edgeFadeBottomStop = 0.85,
  });

  final List<Line> lyricsLines;
  final Map<int, CueLine>? cueLinesByStart;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets itemPadding;
  final double primaryFontSize;
  final double secondaryFontSize;
  final double blurFactor;
  final double activeScaleDelta;
  final double firstScrollAlignment;
  final double activeScrollAlignment;
  final Duration activeAnimationDuration;
  final Duration itemAnimationDuration;
  final double edgeFadeTopStop;
  final double edgeFadeBottomStop;

  @override
  ConsumerState<AnimatedLyricsPanel> createState() =>
      _AnimatedLyricsPanelState();
}

class _AnimatedLyricsPanelState extends ConsumerState<AnimatedLyricsPanel> {
  int _currentIndex = -1;
  // 当前播放位置（毫秒）。仅在行变化时触发 setState；逐字平滑由 active item
  // 自身的 AnimationController 驱动，通过此 notifier 做周期性对齐。
  final ValueNotifier<int> _positionMs = ValueNotifier<int>(0);
  StreamSubscription<Duration>? _positionStream;

  @override
  void initState() {
    super.initState();
    _setPositionListener();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _positionMs.dispose();
    super.dispose();
  }

  void _setPositionListener() async {
    if (_positionStream != null) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (!mounted) return;
    _positionStream = player?.positionStream.listen((position) {
      _positionMs.value = position.inMilliseconds;
      _scrollLyrics(position: position);
    });
  }

  void _scrollLyrics({required Duration position}) {
    final currentLineIdx = indexOfLyrics(
      sortedLyrics: widget.lyricsLines,
      position: position,
    );
    // 位置始终更新给 active item 做对齐（不触发重建）。
    if (_currentIndex == currentLineIdx) return;

    final animateDuration = _currentIndex == -1
        ? Duration.zero
        : widget.activeAnimationDuration;

    setState(() {
      _currentIndex = currentLineIdx;
    });

    final start = widget.lyricsLines[currentLineIdx].start;
    if (start == null) return;
    final gContext = GlobalObjectKey(start).currentContext;
    if (gContext == null || !context.mounted) return;
    Scrollable.ensureVisible(
      gContext,
      alignment: _currentIndex == -1
          ? widget.firstScrollAlignment
          : widget.activeScrollAlignment,
      duration: animateDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final edgeFadeColor = colorScheme.scrim;
    return LayoutBuilder(
      builder: (context, constraints) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [
            edgeFadeColor.withValues(alpha: 0),
            edgeFadeColor,
            edgeFadeColor,
            edgeFadeColor.withValues(alpha: 0),
          ],
          stops: [0, widget.edgeFadeTopStop, widget.edgeFadeBottomStop, 1],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight / 2),
              ..._items(colorScheme),
              SizedBox(height: constraints.maxHeight / 2),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _items(ColorScheme colorScheme) {
    return List.generate(widget.lyricsLines.length, (idx) {
      final line = widget.lyricsLines[idx];
      final text = line.value;
      if (text == null || text.isEmpty) {
        return SizedBox.shrink(key: GlobalObjectKey(line.start ?? ''));
      }
      final cueLine = widget.cueLinesByStart?[line.start];
      return _AnimatedLyricsItem(
        key: GlobalObjectKey(line.start ?? ''),
        line: line,
        cueLine: cueLine,
        isActive: _currentIndex == idx,
        positionMs: _positionMs,
        colorScheme: colorScheme,
        textAlign: widget.textAlign,
        itemPadding: widget.itemPadding,
        primaryFontSize: widget.primaryFontSize,
        secondaryFontSize: widget.secondaryFontSize,
        blurFactor: widget.blurFactor,
        activeScaleDelta: widget.activeScaleDelta,
        itemAnimationDuration: widget.itemAnimationDuration,
      );
    });
  }
}

/// 单行歌词。逐字（karaoke）模式由 [AnimationController] 在 60fps 驱动；
/// 无 [cueLine] 或非当前行时回退到整行 TweenAnimationBuilder 高亮。
class _AnimatedLyricsItem extends StatefulWidget {
  const _AnimatedLyricsItem({
    super.key,
    required this.line,
    required this.cueLine,
    required this.isActive,
    required this.positionMs,
    required this.colorScheme,
    required this.textAlign,
    required this.itemPadding,
    required this.primaryFontSize,
    required this.secondaryFontSize,
    required this.blurFactor,
    required this.activeScaleDelta,
    required this.itemAnimationDuration,
  });

  final Line line;
  final CueLine? cueLine;
  final bool isActive;
  final ValueNotifier<int> positionMs;
  final ColorScheme colorScheme;
  final TextAlign textAlign;
  final EdgeInsets itemPadding;
  final double primaryFontSize;
  final double secondaryFontSize;
  final double blurFactor;
  final double activeScaleDelta;
  final Duration itemAnimationDuration;

  @override
  State<_AnimatedLyricsItem> createState() => _AnimatedLyricsItemState();
}

class _AnimatedLyricsItemState extends State<_AnimatedLyricsItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  // 是否处于逐字渲染模式（仅当本行有 cue 且为当前行时为 true）。
  bool _karaoke = false;
  // 目标相位（由 positionMs 推导，0..1）。
  double _targetFraction = 0.0;
  // 实际渲染相位，每帧朝目标做指数趋近，保证 60fps 平滑且单调推进。
  double _renderFraction = 0.0;

  CueLine get _cueLine => widget.cueLine!;

  int get _lineStart => _cueLine.start ?? widget.line.start ?? 0;
  int get _lineEnd => _cueLine.end ?? _lineStart;
  int get _lineSpan => (_lineEnd - _lineStart).clamp(1, 10000);

  @override
  void initState() {
    super.initState();
    _setupKaraoke();
  }

  @override
  void didUpdateWidget(covariant _AnimatedLyricsItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupKaraoke();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _setupKaraoke() {
    final shouldRun = widget.isActive && widget.cueLine != null;
    if (shouldRun == _karaoke && _controller != null) return;

    if (shouldRun) {
      // 控制器仅用作 60fps 节拍源（repeat 持续触发 listener）；实际渲染
      // 相位由 _renderFraction 朝 _targetFraction 指数趋近得出，单调不循环。
      _controller ??= AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
      _karaoke = true;
      _updateTarget();
      _renderFraction = _targetFraction; // 变 active 时从当前进度起步，避免跳变
      _controller!.value = 0;
      _controller!.repeat();
    } else {
      _controller?.stop();
      _karaoke = false;
    }
  }

  /// 依据当前播放位置更新目标相位。位置流 ~4-10Hz 更新此值；渲染相位每帧
  /// 朝它趋近，补足帧间平滑度，并纠正 media_kit 时钟漂移。
  void _updateTarget() {
    _targetFraction =
        ((widget.positionMs.value - _lineStart) / _lineSpan).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.line.value ?? '';
    if (text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: widget.itemPadding,
      child: _karaoke ? _buildKaraoke() : _buildStatic(),
    );
  }

  /// 逐字渲染：Text.rich，每个 cue 的颜色按毫秒进度 lerp。
  /// 渲染相位以指数趋近 [_targetFraction]，提供 60fps 平滑且单调推进。
  Widget _buildKaraoke() {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller!, widget.positionMs]),
      builder: (context, _) {
        _updateTarget();
        // 指数趋近：每帧把渲染值向目标推进约 18%，约 5 帧内基本贴合，视觉平滑。
        _renderFraction =
            _renderFraction + (_targetFraction - _renderFraction) * 0.18;
        if ((_targetFraction - _renderFraction).abs() < 0.001) {
          _renderFraction = _targetFraction;
        }
        final renderMs = _lineStart + (_renderFraction * _lineSpan).round();
        return _karaokeText(renderMs);
      },
    );
  }

  Widget _karaokeText(int positionMs) {
    final cues = _cueLine.cue ?? const <Cue>[];
    final sweep = cueLineSweepFraction(cues: cues, positionMs: positionMs);
    // 每字放大因子：正在唱的字鼓起到 1.06，已唱/未唱回落到 0.96，拉开层次。
    // 幅度刻意压小，避免逐字字号变化引起整行宽度抖动。
    final scales = cueScaleByStartMs(
      cues: cues,
      positionMs: positionMs,
      baseline: 0.96,
      peak: 1.06,
    );
    final inactive = widget.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    final active = widget.colorScheme.primary;

    // 颜色仍由整行 ShaderMask 统一管（span 不设 color），保证左→右扫过分界
    // 不被 per-span 颜色打乱。字号 per-span 变化提供体量感。
    final softness = (0.06).clamp(0.0, sweep < 1.0 ? (1.0 - sweep) * 0.5 : 0.0);
    final leftStop = (sweep - softness).clamp(0.0, 1.0);
    final rightStop = (sweep + softness).clamp(0.0, 1.0);

    final text = Text.rich(
      TextSpan(
        // 不设 color，由 ShaderMask 着色。
        children: [
          for (var i = 0; i < cues.length; i++)
            TextSpan(
              text: cues[i].value ?? '',
              style: TextStyle(
                fontSize: widget.primaryFontSize * scales[i],
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      textAlign: widget.textAlign,
    );

    final content = ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [active, active, inactive, inactive],
        stops: [0.0, leftStop, rightStop, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: text,
    );

    // 非当前行（理论上 _karaoke 已为 false）仍套一层缩放。
    return Transform.scale(scale: 1 + widget.activeScaleDelta, child: content);
  }

  /// 整行高亮回退路径（无 cue，或非当前行）。
  Widget _buildStatic() {
    return TweenAnimationBuilder<double>(
      duration: widget.itemAnimationDuration,
      curve: Curves.easeOutCubic,
      tween: Tween(end: widget.isActive ? 1 : 0),
      builder: (context, value, _) {
        final sigma = widget.blurFactor * (1 - value);
        final scale = 1 + (widget.activeScaleDelta * value);

        Widget content = Text(
          widget.line.value ?? '',
          textAlign: widget.textAlign,
          style: TextStyle(
            fontSize: widget.primaryFontSize,
            height: 1.5,
            color: Color.lerp(
              widget.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              widget.colorScheme.primary,
              value,
            ),
            fontWeight: value > 0.5 ? .bold : .normal,
          ),
        );

        if (value < .99) {
          content = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: content,
          );
        }
        return Transform.scale(scale: scale, child: content);
      },
    );
  }
}
