import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/library/widgets/view_types.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_page_controls.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/song/songs.dart';
import 'package:melo_trip/widget/artwork_image.dart';

import 'package:melo_trip/app_player/player.dart';

part 'parts/song_page_sections.dart';

const int kSongPageSize = 50;
const SongSearchQuery kDesktopSongsQuery = SongSearchQuery(
  query: '',
  songCount: kSongPageSize,
  albumCount: 0,
  artistCount: 0,
);

class DesktopSongsPage extends ConsumerStatefulWidget {
  const DesktopSongsPage({super.key});

  @override
  ConsumerState<DesktopSongsPage> createState() => _DesktopSongsPageState();
}

class _DesktopSongsPageState extends ConsumerState<DesktopSongsPage> {
  final ScrollController _scrollController = ScrollController();
  AppViewType _viewType = AppViewType.table;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref
          .read(paginatedSongListProvider(kDesktopSongsQuery).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(paginatedSongListProvider(kDesktopSongsQuery));
    final Color headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.7,
    );
    final TextStyle headerStyle = kSongTableHeaderStyle.copyWith(
      color: headerColor,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          SongPageHeader(
            title: l10n.song,
            count: state.items.length,
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          const SongPageToolbar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text('#', style: headerStyle)),
                Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
                SizedBox(
                  width: 60,
                  child: Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: headerColor,
                  ),
                ),
                Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
                Expanded(
                  flex: 2,
                  child: Text(l10n.songMetaGenre, style: headerStyle),
                ),
                SizedBox(
                  width: 60,
                  child: Text(l10n.songMetaYear, style: headerStyle),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          Expanded(
            child: state.items.isEmpty && state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final SongEntity song = state.items[index];
                      return SongTrackRow(index: index + 1, song: song);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
