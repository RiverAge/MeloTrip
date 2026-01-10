import 'dart:math' as math;
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const TypingIndicator({
    super.key,
    this.size = 24.0, // 默认大小
    this.color,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 创建循环动画
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final dotSize = widget.size / 3; // 每个点的大小

    return Align(
      child: SizedBox(
        width: widget.size,
        height: dotSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                // 核心魔法：使用正弦波计算每个点的延迟
                // index * 0.2 制造了波浪的时间差
                final delay = index * 0.2;
                final value = math.sin(
                  (_controller.value * 2 * math.pi) - delay,
                );

                // 映射 value (-1 到 1) 到我们需要的大小/透明度范围
                // 这里我们让它在 0.5 到 1.0 之间缩放，或者改变透明度
                final scale = 0.5 + (0.5 * (0.5 * value + 0.5));
                // 或者控制透明度：
                final opacity = 0.4 + (0.6 * (0.5 * value + 0.5));

                return Transform.scale(
                  scale: scale, // 缩放效果
                  child: Opacity(
                    opacity: opacity, // 闪烁效果（截图里的深浅变化）
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
