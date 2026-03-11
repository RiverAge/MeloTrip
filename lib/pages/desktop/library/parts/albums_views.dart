import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

// ──────────────────────────────────────
// Grid view
// ──────────────────────────────────────
class AlbumGridView extends StatelessWidget {
  const AlbumGridView({
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
    final itemCount = albums.length + (hasMore ? 1 : 0);
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= albums.length) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return DesktopAlbumCard(album: albums[index]);
      },
    );
  }
}

// ──────────────────────────────────────
// Table view
// ──────────────────────────────────────
class AlbumTableView extends StatelessWidget {
  const AlbumTableView({
    super.key,
    required this.albums,
    required this.hasMore,
    required this.scrollController,
    required this.l10n,
  });
  final List<AlbumEntity> albums;
  final bool hasMore;
  final ScrollController scrollController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: .7,
    );
    final headerStyle = _baseStyle.copyWith(color: headerColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              SizedBox(
                width: 80,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: headerColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              SizedBox(
                width: 80,
                child: Text(l10n.songMetaYear, style: headerStyle),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: .3),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: albums.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= albums.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return _AlbumTableRow(index: index + 1, album: albums[index]);
            },
          ),
        ),
      ],
    );
  }

  static const _baseStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

class _AlbumTableRow extends StatelessWidget {
  const _AlbumTableRow({required this.index, required this.album});
  final int index;
  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ArtworkImage(
                      id: album.id,
                      size: 80,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.name ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          album.artist ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                _formatTotalDuration(album.duration),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                album.genre ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                '${album.year ?? ""}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTotalDuration(int? seconds) {
    if (seconds == null) return '-';
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ──────────────────────────────────────
// Detail list view
// ──────────────────────────────────────
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ArtworkImage(
                    id: album.id,
                    size: 500,
                    width: 240,
                    height: 240,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  album.name ?? '-',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                Text(
                  album.artist ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${album.year ?? ""} • ${album.songCount ?? 0}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: AsyncValueBuilder(
              provider: albumDetailProvider(album.id ?? ''),
              builder: (context, data, ref) {
                final songs = data.subsonicResponse?.album?.song ?? [];
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
          SizedBox(
            width: 40,
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
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '0:00';
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
