import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:melo_trip/widget/artwork_image.dart';

class PlaybackArtworkBackground extends StatelessWidget {
  const PlaybackArtworkBackground({
    super.key,
    required this.artworkId,
    this.size = 1200,
    this.fit = .cover,
  });

  final String? artworkId;
  final int size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (artworkId == null || artworkId!.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox.expand(
      child: ArtworkImage(id: artworkId!, fit: fit, size: size),
    );
  }
}

class PlaybackBlurOverlay extends StatelessWidget {
  const PlaybackBlurOverlay({
    super.key,
    this.blurSigma = 30,
    this.surfaceAlpha = .35,
    this.useVignette = true,
  });

  final double blurSigma;
  final double surfaceAlpha;
  final bool useVignette;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: colorScheme.surface.withValues(alpha: surfaceAlpha),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: const SizedBox.expand(),
            ),
          ),
          if (useVignette)
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      colorScheme.scrim.withValues(alpha: 0.18),
                      colorScheme.scrim.withValues(alpha: 0.08),
                      colorScheme.scrim.withValues(alpha: 0.08),
                      colorScheme.scrim.withValues(alpha: 0.2),
                    ],
                    stops: const [0, 0.18, 0.78, 1],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
