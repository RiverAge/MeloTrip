import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class AlbumDetailListView extends StatelessWidget {
  const AlbumDetailListView({
    super.key,
    required this.albums,
    required this.hasMore,
    required this.scrollController,
  });

  final List<AlbumEntity> albums;
  final bool hasMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      itemCount: albums.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= albums.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return _AlbumDetailItem(album: albums[index]);
      },
    );
  }
}

class _AlbumDetailItem extends ConsumerWidget {
  const _AlbumDetailItem({required this.album});

  final AlbumEntity album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final String yearText = (album.year?.toString() ?? '').trim();
    final String summary = <String>[
      if (yearText.isNotEmpty) yearText,
      '${album.songCount ?? 0} ${l10n.songCountUnit}',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ArtworkImage(id: album.id, size: 500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    album.name ?? '-',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                    textAlign: .center,
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                  Text(
                    album.artist ?? '-',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: .center,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    summary,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: AsyncValueBuilder(
              provider: albumDetailProvider(album.id ?? ''),
              builder: (context, data, ref) {
                final List<SongEntity> songs =
                    data.data?.subsonicResponse?.album?.song ?? <SongEntity>[];
                return Column(
                  children: songs
                      .asMap()
                      .entries
                      .map(
                        (entry) => _DetailTrackRow(
                          index: entry.key + 1,
                          song: entry.value,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTrackRow extends StatelessWidget {
  const _DetailTrackRow({required this.index, required this.song});

  final int index;
  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 32, maxWidth: 40),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(song.title ?? '-', style: theme.textTheme.bodyMedium),
          ),
          Text(
            _formatDuration(song.duration),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.favorite_border_rounded,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '0:00';
    final int m = seconds ~/ 60;
    final String s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
