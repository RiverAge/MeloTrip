import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/search_result_tile.dart';
part 'parts/search_section.dart';

class DesktopSearchHistoryPanel extends ConsumerWidget {
  const DesktopSearchHistoryPanel({required this.onSelectQuery, super.key});

  final ValueChanged<String> onSelectQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AsyncValueBuilder<String?>(
      provider: sessionConfigProvider.select(
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
                    ref.read(userSessionProvider.notifier).setConfiguration(
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
    super.key,
  });

  final List<SongEntity> songs;
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;
  final Future<void> Function(SongEntity song) onSongTap;
  final Future<void> Function(AlbumEntity album) onAlbumTap;
  final Future<void> Function(ArtistEntity artist) onArtistTap;
  final int? maxItemsPerSection;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<Widget> sections = <Widget>[
      if (songs.isNotEmpty)
        _SearchSection<SongEntity>(
          title: l10n.song,
          items: _slice(songs),
          itemBuilder: (BuildContext context, SongEntity song) {
            return _SongResultTile(song: song, onTap: () => onSongTap(song));
          },
        ),
      if (albums.isNotEmpty)
        _SearchSection<AlbumEntity>(
          title: l10n.album,
          items: _slice(albums),
          itemBuilder: (BuildContext context, AlbumEntity album) {
            return _AlbumResultTile(
              album: album,
              onTap: () => onAlbumTap(album),
            );
          },
        ),
      if (artists.isNotEmpty)
        _SearchSection<ArtistEntity>(
          title: l10n.artist,
          items: _slice(artists),
          itemBuilder: (BuildContext context, ArtistEntity artist) {
            return _ArtistResultTile(
              artist: artist,
              onTap: () => onArtistTap(artist),
            );
          },
        ),
    ];

    if (sections.isEmpty) {
      return const NoData();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
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
