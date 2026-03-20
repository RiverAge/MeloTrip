import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/album/album_detail.dart';

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
      alpha: 0.7,
    );
    final headerStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ).copyWith(color: headerColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text('#', style: headerStyle),
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: headerColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: Text(
                      l10n.songMetaYear,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: headerStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
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
}

class _AlbumTableRow extends ConsumerStatefulWidget {
  const _AlbumTableRow({required this.index, required this.album});

  final int index;
  final AlbumEntity album;

  @override
  ConsumerState<_AlbumTableRow> createState() => _AlbumTableRowState();
}

class _AlbumTableRowState extends ConsumerState<_AlbumTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final album = widget.album;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DesktopAlbumDetailPage(albumId: album.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text(
                      '${widget.index}',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
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
                        if (_isHovered)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.scrim.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.play_arrow_rounded,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                  onPressed: () async {
                                    final albumData = await ref.read(
                                      albumDetailProvider(album.id).future,
                                    );
                                    final songs = albumData
                                        ?.data
                                        ?.subsonicResponse
                                        ?.album
                                        ?.song;
                                    if (songs != null && songs.isNotEmpty) {
                                      final player = await ref.read(
                                        appPlayerHandlerProvider.future,
                                      );
                                      if (player != null) {
                                        await player.setPlaylist(
                                          songs: songs,
                                          initialId: songs.first.id,
                                        );
                                        await player.play();
                                      }
                                    }
                                  },
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album.name ?? '-',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            album.artist ?? '-',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: Text(
                      _formatTotalDuration(album.duration),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  album.genre ?? '-',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: Text(
                      '${album.year ?? ""}',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.favorite_border_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTotalDuration(int? seconds) {
    if (seconds == null) return '-';
    final int m = seconds ~/ 60;
    final String s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
