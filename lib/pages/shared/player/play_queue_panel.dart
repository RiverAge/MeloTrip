import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/play_queue_header.dart';
part 'parts/play_queue_controls.dart';
part 'parts/play_queue_list.dart';
part 'parts/play_queue_search.dart';

enum PlayQueuePanelVariant { mobile, desktop }

/// Visual style of the inline play-queue search field.
enum PlayQueueSearchStyle {
  /// Input merged into the header pill button group, expanding to fill the
  /// row when active (hiding the title and the mode/shuffle/clear buttons).
  headerInline,
}

@visibleForTesting
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
showAutoClosingSnackBar(
  ScaffoldMessengerState messenger, {
  required SnackBar snackBar,
  required Duration dismissAfter,
}) {
  final controller = messenger.showSnackBar(snackBar);
  // SnackBars with actions can stay open under accessible navigation settings.
  var isClosed = false;
  unawaited(controller.closed.whenComplete(() => isClosed = true));
  unawaited(
    Future<void>.delayed(dismissAfter, () {
      if (!isClosed && messenger.mounted) {
        controller.close();
      }
    }),
  );
  return controller;
}

double? computePlayQueueJumpOffset({
  required int index,
  required int songCount,
  required double maxScrollExtent,
  double itemExtent = 72.0,
  double edgePadding = 23.0,
}) {
  if (index < 0 || index >= songCount || !maxScrollExtent.isFinite) {
    return null;
  }
  final safeMaxOffset = (maxScrollExtent - edgePadding).clamp(
    0.0,
    double.infinity,
  );
  final targetOffset = index * itemExtent;
  return targetOffset.clamp(0.0, safeMaxOffset).toDouble();
}

class PlayQueuePanel extends ConsumerStatefulWidget {
  const PlayQueuePanel({
    super.key,
    required this.variant,
    this.onClose,
    this.closeAfterClear = false,
    this.closeOnSelection = false,
    this.searchStyle = PlayQueueSearchStyle.headerInline,
  });

  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;
  final bool closeOnSelection;
  final PlayQueueSearchStyle searchStyle;

  @override
  ConsumerState<PlayQueuePanel> createState() => _PlayQueuePanelState();
}

class _PlayQueuePanelState extends ConsumerState<PlayQueuePanel> {
  final TextEditingController _searchController = TextEditingController();
  bool _searchExpanded = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query != _searchQuery) {
      setState(() => _searchQuery = query);
    }
  }

  void _toggleSearch() {
    setState(() {
      _searchExpanded = !_searchExpanded;
      if (!_searchExpanded) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return Column(
          children: [
            _PlayQueueHeader(
              player: player,
              variant: widget.variant,
              closeAfterClear: widget.closeAfterClear,
              onClose: widget.onClose,
              searchExpanded: _searchExpanded,
              onToggleSearch: _toggleSearch,
              searchStyle: widget.searchStyle,
              searchController: _searchController,
            ),
            Expanded(
              child: PlayQueueBuilder(
                builder: (_, playQueue, _) {
                  if (playQueue.songs.isEmpty) {
                    return const NoData();
                  }
                  if (_searchExpanded && _searchQuery.isNotEmpty &&
                      _matchIndices(playQueue.songs, _searchQuery).isEmpty) {
                    return _PlayQueueNoMatch();
                  }
                  return _PlayQueueListView(
                    playQueue: playQueue,
                    player: player,
                    variant: widget.variant,
                    closeOnSelection: widget.closeOnSelection,
                    searchQuery: _searchExpanded ? _searchQuery : '',
                  );
                },
              ),
            ),
            if (widget.variant == PlayQueuePanelVariant.desktop)
              Container(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
          ],
        );
      },
    );
  }
}

/// Returns the original-queue indices of songs matching [query]
/// (case-insensitive against title / artist / album).
List<int> _matchIndices(List<SongEntity> songs, String query) {
  return songs.indexed
      .where((e) {
        final s = e.$2;
        final title = (s.title ?? '').toLowerCase();
        final artist = (s.displayArtist ?? s.artist ?? '').toLowerCase();
        final album = (s.album ?? '').toLowerCase();
        return title.contains(query) ||
            artist.contains(query) ||
            album.contains(query);
      })
      .map((e) => e.$1)
      .toList();
}
