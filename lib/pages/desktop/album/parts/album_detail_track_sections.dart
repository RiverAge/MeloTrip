part of '../album_detail_page.dart';

class _AlbumTrackList extends StatelessWidget {
  const _AlbumTrackList({
    required this.album,
    required this.songs,
    required this.onPlaySong,
  });

  final AlbumEntity album;
  final List<SongEntity> songs;
  final Future<void> Function(WidgetRef ref, SongEntity song) onPlaySong;

  @override
  Widget build(BuildContext context) {
    final List<_TrackRow> rows = _buildRows(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final _TrackRow row = rows[index];
          return switch (row) {
            _DiscHeaderRow() => _DiscHeaderTile(row: row),
            _TrackSongRow() => Consumer(
              builder: (context, ref, _) {
                return _TrackListTile(
                  index: row.trackIndex,
                  song: row.song,
                  onPlay: () => onPlaySong(ref, row.song),
                );
              },
            ),
          };
        }, childCount: rows.length),
      ),
    );
  }

  List<_TrackRow> _buildRows(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<_TrackRow> rows = <_TrackRow>[];
    int? previousDiscNumber;
    final Map<int, String?> discTitleMap = <int, String?>{
      for (final DiscTitle discTitle in album.discTitles ?? const <DiscTitle>[])
        if (discTitle.disc != null) discTitle.disc!: discTitle.title,
    };

    for (int i = 0; i < songs.length; i++) {
      final SongEntity song = songs[i];
      final int? discNumber = song.discNumber;
      if (i == 0 || previousDiscNumber != discNumber) {
        previousDiscNumber = discNumber;
        final int effectiveDiscNumber = discNumber ?? 1;
        final String? discTitle = discTitleMap[effectiveDiscNumber]?.trim();
        rows.add(
          _DiscHeaderRow(
            label: (discTitle == null || discTitle.isEmpty)
                ? l10n.albumDiscLabel(effectiveDiscNumber)
                : discTitle,
          ),
        );
      }
      rows.add(_TrackSongRow(song: song, trackIndex: i + 1));
    }
    return rows;
  }
}

sealed class _TrackRow {
  const _TrackRow();
}

class _DiscHeaderRow extends _TrackRow {
  const _DiscHeaderRow({required this.label});

  final String label;
}

class _TrackSongRow extends _TrackRow {
  const _TrackSongRow({required this.song, required this.trackIndex});

  final SongEntity song;
  final int trackIndex;
}

class _DiscHeaderTile extends StatelessWidget {
  const _DiscHeaderTile({required this.row});

  final _DiscHeaderRow row;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Align(
        alignment: .centerLeft,
        child: Text(
          row.label,
          textAlign: .left,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 100 / 255),
          ),
        ),
      ),
    );
  }
}

class _AlbumRecommendationsSection extends StatelessWidget {
  const _AlbumRecommendationsSection({required this.album});

  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String? genre = album.genre?.trim();
    final bool hasGenre = genre != null && genre.isNotEmpty;
    final String title = hasGenre ? genre : l10n.recommendedToday;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: .w900,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: AsyncValueBuilder(
                provider: albumListProvider(
                  AlbumListQuery(
                    type: hasGenre ? 'byGenre' : AlbumListType.random.name,
                    genre: hasGenre ? genre : null,
                    size: 20,
                  ),
                ),
                builder: (context, data, _) {
                  if (data.isErr) {
                    return const SizedBox.shrink();
                  }
                  final List<AlbumEntity> albums = (data.data ?? const <AlbumEntity>[])
                      .where((AlbumEntity item) => item.id != album.id)
                      .toList();
                  if (albums.isEmpty) {
                    return const SizedBox.shrink();
                  }
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
