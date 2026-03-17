import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/subsonic_uri_builder.dart';
import 'package:melo_trip/provider/auth/auth.dart';

class ArtworkImage extends ConsumerStatefulWidget {
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
  ConsumerState<ArtworkImage> createState() => _ArtworkImageState();
}

class _ArtworkImageState extends ConsumerState<ArtworkImage> {
  String? _currentUrl;
  Future<Uint8List>? _imageBytesFuture;

  @override
  Widget build(BuildContext context) {
    final artworkId = widget.id;
    if (artworkId == null) {
      return widget.errorWidget ?? _buildPlaceholder(context);
    }

    final auth = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return switch (auth) {
      AsyncData(:final value) => _buildTrackedImage(
        theme: theme,
        imageUrl: SubsonicUriBuilder.buildCoverArtUri(
          auth: value,
          artworkId: artworkId,
          size: widget.size,
        ).toString(),
      ),
      AsyncError() => widget.errorWidget ?? const Icon(Icons.error),
      _ => widget.placeholder ?? _buildPlaceholder(context),
    };
  }

  Widget _buildTrackedImage({
    required ThemeData theme,
    required String imageUrl,
  }) {
    if (_currentUrl != imageUrl) {
      _currentUrl = imageUrl;
      final request = _ArtworkImageRequestPool.acquire(imageUrl);
      _imageBytesFuture = request.future;
    }

    return FutureBuilder<Uint8List>(
      future: _imageBytesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.placeholder ?? _buildPlaceholder(context);
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return widget.errorWidget ??
              Container(
                width: widget.width,
                height: widget.height,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                  size: 24,
                ),
              );
        }
        return Image.memory(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          cacheWidth: widget.size,
          cacheHeight: widget.size,
          gaplessPlayback: true,
          errorBuilder: (context, _, _) => widget.errorWidget ?? _buildError(theme),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: widget.width,
      height: widget.height,
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

  Widget _buildError(ThemeData theme) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: 24,
      ),
    );
  }
}

class _ArtworkRequestHandle {
  const _ArtworkRequestHandle({required this.future});

  final Future<Uint8List> future;
}

class _ArtworkImageRequestPool {
  static const int _maxConcurrentRequests = 4;
  static final Map<String, Future<Uint8List>> _inflight =
      <String, Future<Uint8List>>{};
  static final List<Completer<void>> _waiters = <Completer<void>>[];
  static int _activeRequests = 0;

  static _ArtworkRequestHandle acquire(String url) {
    final existing = _inflight[url];
    if (existing != null) {
      return _ArtworkRequestHandle(future: existing);
    }
    final future = _withPermit(() => _download(url));
    _inflight[url] = future;
    future.whenComplete(() {
      _inflight.remove(url);
    });
    return _ArtworkRequestHandle(future: future);
  }

  static Future<T> _withPermit<T>(Future<T> Function() action) async {
    await _acquirePermit();
    try {
      return await action();
    } finally {
      _releasePermit();
    }
  }

  static Future<void> _acquirePermit() async {
    if (_activeRequests < _maxConcurrentRequests) {
      _activeRequests++;
      return;
    }
    final waiter = Completer<void>();
    _waiters.add(waiter);
    await waiter.future;
  }

  static void _releasePermit() {
    if (_waiters.isNotEmpty) {
      final waiter = _waiters.removeAt(0);
      waiter.complete();
      return;
    }
    _activeRequests--;
  }

  static Future<Uint8List> _download(String url) async {
    final data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
