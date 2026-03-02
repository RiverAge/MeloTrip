part of 'music_bar.dart';

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

class _BottomSheetPlayQueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AsyncValueBuilder(
    provider: appPlayerHandlerProvider,
    builder: (context, player, _) => SafeArea(
      child: Column(
        children: [
          GestureHint(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0),
            child: Row(
              children: [
                Expanded(child: _BottomSheetTitle()),
                _BottomSheePlaylistMode(),
                _BottomSheetShuffleMode(),
                Builder(
                  builder: (context) {
                    final playQueue = player.playQueue;
                    if (playQueue.songs.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return IconButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messager = ScaffoldMessenger.of(context);
                        final localizations = AppLocalizations.of(context);
                        await player.setPlaylist(songs: []);
                        navigator.pop();
                        messager.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 6),
                            content: Text(localizations!.deleted),
                            action: SnackBarAction(
                              label: localizations.revoke,
                              onPressed: () {
                                player.setPlaylist(
                                  songs: playQueue.songs,
                                  initialId:
                                      playQueue.songs[playQueue.index].id,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.clear_all_outlined),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PlayQueueBuilder(
              builder: (_, playQueue, _) {
                if (playQueue.songs.isEmpty) {
                  return NoData();
                }
                return _PlayQueueListView(playQueue: playQueue, player: player);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _PlayQueueListView extends ConsumerStatefulWidget {
  const _PlayQueueListView({required this.playQueue, required this.player});
  final PlayQueue playQueue;
  final AppPlayer player;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlayQueueListViewState();
}

class _PlayQueueListViewState extends ConsumerState<_PlayQueueListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setPositionListener();
    });
  }

  void _setPositionListener() {
    if (!_scrollController.hasClients) {
      return;
    }

    final finalOffset = computePlayQueueJumpOffset(
      index: widget.playQueue.index,
      songCount: widget.playQueue.songs.length,
      maxScrollExtent: _scrollController.position.maxScrollExtent,
    );

    if (finalOffset == null) {
      debugPrint(
        'PlayQueue jump skipped: index=${widget.playQueue.index}, '
        'count=${widget.playQueue.songs.length}, '
        'max=${_scrollController.position.maxScrollExtent}',
      );
      return;
    }

    _scrollController.jumpTo(finalOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
      provider: widget.player.playingStream,
      loading: (_) => _buildListView(player: widget.player, playing: false),
      builder: (_, playing) {
        return _buildListView(player: widget.player, playing: playing);
      },
    );
  }

  Widget _buildListView({required AppPlayer player, required bool playing}) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8),
      controller: _scrollController,
      itemExtent: 72,
      itemCount: widget.playQueue.songs.length,
      itemBuilder: (context, idx) {
        return _BottomSheetItem(
          player: player,
          songs: widget.playQueue.songs,
          currentPlayingIndex: widget.playQueue.index,
          index: idx,
          isCurrentPlaying: playing && widget.playQueue.index == idx,
        );
      },
    );
  }
}
