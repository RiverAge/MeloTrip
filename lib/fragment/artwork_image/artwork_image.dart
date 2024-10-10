import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artwork_image.g.dart';

class ArtworkImage extends ConsumerWidget {
  const ArtworkImage(
      {super.key, required this.id, this.fit, this.size, this.imageBuilder});

  final String? id;
  final BoxFit? fit;
  final int? size;
  final ImageWidgetBuilder? imageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkId = id;
    if (artworkId == null) {
      return const SizedBox.shrink();
    }
    final AsyncValue<String> url = ref.watch(ArtworkUrlProvider(artworkId));
    return switch (url) {
      AsyncData(:final value) => CachedNetworkImage(
          imageUrl: '$value&size=${size ?? 100}',
          fit: fit,
          imageBuilder: imageBuilder,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  value: progress.progress,
                ),
              ),
            ),
          ),
        ),
      AsyncError() => const Icon(Icons.error),
      _ => const FixedCenterCircular(
          strokeWidth: 1.5,
        ),
    };
  }
}

@riverpod
Future<String> artworkUrl(ArtworkUrlRef ref, String id) async {
  final url =
      await buildSubsonicUrl('/rest/getCoverArt?id=$id', withHost: true);
  return url;
}
