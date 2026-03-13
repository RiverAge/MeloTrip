import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/provider/auth/auth.dart';

class ArtworkImage extends ConsumerWidget {
  const ArtworkImage({
    super.key,
    required this.id,
    this.fit,
    this.size,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  final String? id;
  final BoxFit? fit;
  final int? size;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkId = id;
    if (artworkId == null) {
      return errorWidget ?? _buildPlaceholder(context);
    }

    final auth = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return switch (auth) {
      AsyncData(:final value) => Image.network(
        _buildArtworkUrl(
          artworkId: artworkId,
          host: value?.host,
          username: value?.username,
          token: value?.token,
          salt: value?.salt,
        ),
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return placeholder ?? _buildPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
                size: 24,
              ),
            ),
      ),
      AsyncError() => errorWidget ?? const Icon(Icons.error),
      _ => placeholder ?? _buildPlaceholder(context),
    };
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          size: 32,
        ),
      ),
    );
  }

  String _buildArtworkUrl({
    required String artworkId,
    required String? host,
    required String? username,
    required String? token,
    required String? salt,
  }) {
    final baseHost = kIsWeb ? host : proxyCacheHost;
    final normalizedBase =
        (baseHost == null || baseHost.isEmpty)
            ? proxyCacheHost
            : baseHost.endsWith('/')
            ? baseHost.substring(0, baseHost.length - 1)
            : baseHost;
    final query = <String, String>{
      'id': artworkId,
      'f': 'json',
      'v': '1.8.0',
      'c': 'MeloTrip',
      'size': '${size ?? 500}',
      if (username != null && username.isNotEmpty) 'u': username,
      if (token != null && token.isNotEmpty) 't': token,
      if (salt != null && salt.isNotEmpty) 's': salt,
    };
    return Uri.parse('$normalizedBase/rest/getCoverArt').replace(
      queryParameters: query,
    ).toString();
  }
}
