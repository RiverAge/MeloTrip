import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopSearchHistoryPanel extends ConsumerWidget {
  const DesktopSearchHistoryPanel({required this.onSelectQuery, super.key});

  final ValueChanged<String> onSelectQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AsyncValueBuilder<String?>(
      provider: userConfigProvider.select(
        (AsyncValue<Configuration?> value) =>
            value.whenData((Configuration? config) => config?.recentSearches),
      ),
      loading: (_, _) => const SizedBox.shrink(),
      builder: (BuildContext context, String? recentStr, WidgetRef ref) {
        final List<String> searches =
            recentStr
                ?.split(',')
                .where((String value) => value.isNotEmpty)
                .toList() ??
            <String>[];
        if (searches.isEmpty) {
          return const Center(child: NoData());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  l10n.searchHistory,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: .w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ref.read(userConfigProvider.notifier).setConfiguration(
                      recentSearches: const ValueUpdater<String>(''),
                    );
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: searches.map((String value) {
                return ActionChip(
                  label: Text(value),
                  onPressed: () => onSelectQuery(value),
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class DesktopSearchResultsView extends StatelessWidget {
  const DesktopSearchResultsView({
    required this.songs,
    required this.albums,
    required this.artists,
    required this.onSongTap,
    required this.onAlbumTap,
    required this.onArtistTap,
    this.maxItemsPerSection,
    this.compact = false,
    super.key,
  });

  final List<SongEntity> songs;
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;
  final Future<void> Function(SongEntity song) onSongTap;
  final Future<void> Function(AlbumEntity album) onAlbumTap;
  final Future<void> Function(ArtistEntity artist) onArtistTap;
  final int? maxItemsPerSection;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<Widget> sections = <Widget>[
      if (songs.isNotEmpty)
        _SearchSection<SongEntity>(
          title: l10n.song,
          items: _slice(songs),
          compact: compact,
          itemBuilder: (BuildContext context, SongEntity song) {
            return _SongResultTile(song: song, compact: compact, onTap: () => onSongTap(song));
          },
        ),
      if (albums.isNotEmpty)
        _SearchSection<AlbumEntity>(
          title: l10n.album,
          items: _slice(albums),
          compact: compact,
          itemBuilder: (BuildContext context, AlbumEntity album) {
            return _AlbumResultTile(
              album: album,
              compact: compact,
              onTap: () => onAlbumTap(album),
            );
          },
        ),
      if (artists.isNotEmpty)
        _SearchSection<ArtistEntity>(
          title: l10n.artist,
          items: _slice(artists),
          compact: compact,
          itemBuilder: (BuildContext context, ArtistEntity artist) {
            return _ArtistResultTile(
              artist: artist,
              compact: compact,
              onTap: () => onArtistTap(artist),
            );
          },
        ),
    ];

    if (sections.isEmpty) {
      return const NoData();
    }

    return ListView.separated(
      padding: EdgeInsets.all(compact ? 12 : 16),
      itemCount: sections.length,
      separatorBuilder: (_, _) => SizedBox(height: compact ? 12 : 16),
      itemBuilder: (_, int index) => sections[index],
    );
  }

  List<T> _slice<T>(List<T> items) {
    final int? maxItems = maxItemsPerSection;
    if (maxItems == null || items.length <= maxItems) {
      return items;
    }
    return items.take(maxItems).toList();
  }
}

class _SearchSection<T> extends StatelessWidget {
  const _SearchSection({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.compact,
  });

  final String title;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(
          alpha: compact ? 0.42 : 0.55,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 10 : 12),
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: .w700,
              ),
            ),
            SizedBox(height: compact ? 8 : 10),
            ...items.map((T item) => itemBuilder(context, item)),
          ],
        ),
      ),
    );
  }
}

class _SongResultTile extends StatelessWidget {
  const _SongResultTile({
    required this.song,
    required this.compact,
    required this.onTap,
  });

  final SongEntity song;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      title: song.title ?? '',
      subtitle: _joinNonEmpty(<String?>[song.album, song.artist]),
      artworkId: song.id,
      compact: compact,
      onTap: onTap,
    );
  }
}

class _AlbumResultTile extends StatelessWidget {
  const _AlbumResultTile({
    required this.album,
    required this.compact,
    required this.onTap,
  });

  final AlbumEntity album;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      title: album.name ?? '',
      subtitle: _joinNonEmpty(<String?>[album.artist, album.year?.toString()]),
      artworkId: album.id,
      compact: compact,
      onTap: onTap,
    );
  }
}

class _ArtistResultTile extends StatelessWidget {
  const _ArtistResultTile({
    required this.artist,
    required this.compact,
    required this.onTap,
  });

  final ArtistEntity artist;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return _ResultTile(
      title: artist.name ?? '',
      subtitle: artist.albumCount == null
          ? ''
          : '${artist.albumCount} ${l10n.albumCount}',
      artworkId: artist.coverArt,
      compact: compact,
      onTap: onTap,
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.title,
    required this.subtitle,
    required this.artworkId,
    required this.compact,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? artworkId;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double artworkSize = compact ? 42 : 52;
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 6 : 8,
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ArtworkImage(
                  id: artworkId,
                  width: artworkSize,
                  height: artworkSize,
                  size: 200,
                  fit: .cover,
                ),
              ),
              SizedBox(width: compact ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _joinNonEmpty(List<String?> values) {
  return values
      .whereType<String>()
      .where((String value) => value.isNotEmpty)
      .join(' - ');
}
