import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/artist/artist_detail_page.dart';
import 'package:melo_trip/pages/desktop/search/search_shared_widgets.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopSearchPage extends ConsumerStatefulWidget {
  const DesktopSearchPage({this.initialQuery, super.key});

  final String? initialQuery;

  @override
  ConsumerState<DesktopSearchPage> createState() => _DesktopSearchPageState();
}

class _DesktopSearchPageState extends ConsumerState<DesktopSearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final String initialQuery = widget.initialQuery?.trim() ?? '';
    _controller = TextEditingController(text: initialQuery);
    Future<void>.microtask(() {
      ref.read(searchQueryProvider.notifier).state = initialQuery;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory(String value) async {
    await ref
        .read(userConfigProvider.notifier)
        .setConfiguration(recentSearch: ValueUpdater<String>(value));
  }

  Future<void> _openAlbum(String? albumId) async {
    if (!mounted || albumId == null || albumId.isEmpty) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DesktopAlbumDetailPage(albumId: albumId),
      ),
    );
  }

  Future<void> _openArtist(String? artistId) async {
    if (!mounted || artistId == null || artistId.isEmpty) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DesktopArtistDetailPage(artistId: artistId),
      ),
    );
  }

  Future<void> _playSong(SongEntity song) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    await player?.playOrToggleFromSongTap(song);
    await _saveToHistory(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String query = ref.watch(searchQueryProvider).trim();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
        title: Text(l10n.searchHint),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              onChanged: (String value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              onSubmitted: _saveToHistory,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.6,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: query.isEmpty
                  ? DesktopSearchHistoryPanel(
                      onSelectQuery: (String value) {
                        _controller.text = value;
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    )
                      : AsyncValueBuilder(
                          provider: searchProvider,
                          loading: (_, _) =>
                              const Center(child: CircularProgressIndicator()),
                          empty: (_, _) => const NoData(),
                          builder: (BuildContext context, result, WidgetRef ref) {
                            if (result.isErr) {
                              return const NoData();
                            }
                            final searchResult =
                                result.data?.subsonicResponse?.searchResult3;
                            return DesktopSearchResultsView(
                              songs: searchResult?.song ?? const <SongEntity>[],
                          albums: searchResult?.album ?? const <AlbumEntity>[],
                          artists:
                              searchResult?.artist ?? const <ArtistEntity>[],
                          onSongTap: _playSong,
                          onAlbumTap: (AlbumEntity album) async {
                            await _saveToHistory(_controller.text);
                            await _openAlbum(album.id);
                          },
                          onArtistTap: (ArtistEntity artist) async {
                            await _saveToHistory(_controller.text);
                            await _openArtist(artist.id);
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

