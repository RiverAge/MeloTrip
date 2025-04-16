import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/artwork_url/artwork_url.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

class ArtworkImage extends ConsumerWidget {
  const ArtworkImage({super.key, required this.id, this.fit, this.size});

  final String? id;
  final BoxFit? fit;
  final int? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkId = id;
    if (artworkId == null) {
      return const SizedBox.shrink();
    }
    final AsyncValue<String> url = ref.watch(ArtworkUrlProvider(artworkId));
    return switch (url) {
      AsyncData(:final value) => Image.network(
        '$value&size=${size ?? 100}',
        fit: fit,
      ),
      AsyncError() => const Icon(Icons.error),
      _ => const FixedCenterCircular(strokeWidth: 1.5),
    };
  }
}
