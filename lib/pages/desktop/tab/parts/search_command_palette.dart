import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/artist/artist_detail_page.dart';
import 'package:melo_trip/pages/desktop/search/search_page.dart';
import 'package:melo_trip/pages/desktop/search/search_shared_widgets.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class SearchCommandPalette extends ConsumerStatefulWidget {
  const SearchCommandPalette({super.key});

  @override
  ConsumerState<SearchCommandPalette> createState() =>
      _SearchCommandPaletteState();
}

class _SearchCommandPaletteState extends ConsumerState<SearchCommandPalette> {
  late final TextEditingController _controller;

  String get _query => _controller.text.trim();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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

  Future<void> _openFullSearch() async {
    if (_query.isEmpty) {
      return;
    }
    await _saveToHistory(_query);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    Navigator.of(context).pop();
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => DesktopSearchPage(initialQuery: _query),
      ),
    );
  }

  Future<void> _playSong(SongEntity song) async {
    await _saveToHistory(_query);
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    await player?.playOrToggleFromSongTap(song);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openAlbum(AlbumEntity album) async {
    if (album.id == null || album.id!.isEmpty) {
      return;
    }
    await _saveToHistory(_query);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    Navigator.of(context).pop();
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => DesktopAlbumDetailPage(albumId: album.id),
      ),
    );
  }

  Future<void> _openArtist(ArtistEntity artist) async {
    if (artist.id == null || artist.id!.isEmpty) {
      return;
    }
    await _saveToHistory(_query);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    Navigator.of(context).pop();
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => DesktopArtistDetailPage(artistId: artist.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 360,
            minHeight: 420,
            maxWidth: 720,
            maxHeight: 560,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.28),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        l10n.searchHint,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: .w700,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _openFullSearch(),
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _query.isEmpty
                      ? DesktopSearchHistoryPanel(
                          onSelectQuery: (String value) {
                            _controller.text = value;
                            setState(() {});
                          },
                        )
                      : AsyncValueBuilder(
                          provider: searchProvider(_query),
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
                              albums:
                                  searchResult?.album ?? const <AlbumEntity>[],
                              artists:
                                  searchResult?.artist ??
                                  const <ArtistEntity>[],
                              maxItemsPerSection: 3,
                              onSongTap: _playSong,
                              onAlbumTap: _openAlbum,
                              onArtistTap: _openArtist,
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: _query.isEmpty ? null : _openFullSearch,
                        child: Text(l10n.viewAll),
                      ),
                      const Spacer(),
                      const _KeyHint(label: 'ESC'),
                      const SizedBox(width: 8),
                      const _KeyHint(icon: Icons.keyboard_return_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({this.label, this.icon});

  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: label != null
          ? Text(
              label!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: .w700,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : Icon(icon, size: 10, color: colorScheme.onSurfaceVariant),
    );
  }
}
