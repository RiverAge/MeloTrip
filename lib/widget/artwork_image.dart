import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

class ArtworkImage extends ConsumerWidget {
  const ArtworkImage({
    super.key,
    required this.id,
    this.fit,
    this.size,
    this.width,
    this.height,
  });

  final String? id;
  final BoxFit? fit;
  final int? size;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkId = id;
    if (artworkId == null) {
      return const SizedBox.shrink();
    }

    final auth = ref.watch(currentUserProvider);
    return switch (auth) {
      AsyncData(:final value) => Image.network(
        '$proxyCacheHost/rest/getCoverArt?id=$artworkId&u=${value?.username}&t=${value?.subsonicToken}&s=${value?.subsonicSalt}&f=json&v=1.8.0&c=MeloTrip&size=${size ?? 100}',
        width: width,
        height: height,
        fit: fit,
      ),
      AsyncError() => const Icon(Icons.error),
      _ => const FixedCenterCircular(strokeWidth: 1.5),
    };
  }
}
