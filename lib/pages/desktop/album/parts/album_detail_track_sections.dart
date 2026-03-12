part of '../album_detail_page.dart';

class _AlbumTrackListToolbar extends StatelessWidget {
  const _AlbumTrackListToolbar();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.searchHint,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  '#',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 24),
                Icon(
                  Icons.swap_vert_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 24),
                Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              thickness: 0.5,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 38,
                  child: Icon(
                    Icons.music_note_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                Text(
                  l10n.song.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(width: 48),
                Icon(
                  Icons.favorite_border_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumTrackList extends StatelessWidget {
  const _AlbumTrackList({required this.songs, required this.onPlaySong});

  final List<SongEntity> songs;
  final Future<void> Function(WidgetRef ref, SongEntity song) onPlaySong;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final SongEntity song = songs[index];
          return Consumer(
            builder: (context, ref, _) {
              return _TrackListTile(
                index: index + 1,
                song: song,
                onPlay: () => onPlaySong(ref, song),
              );
            },
          );
        }, childCount: songs.length),
      ),
    );
  }
}

class _AlbumRecommendationsSection extends StatelessWidget {
  const _AlbumRecommendationsSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.recommendedToday,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: AsyncValueBuilder(
                provider: albumListProvider(AlbumListType.random),
                builder: (context, data, _) {
                  final List<AlbumEntity> albums = data;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    itemBuilder: (_, index) {
                      return _MiniAlbumCard(album: albums[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
