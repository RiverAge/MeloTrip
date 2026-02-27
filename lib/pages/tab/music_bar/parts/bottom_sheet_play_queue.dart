part of 'music_bar.dart';

class _BottomSheetPlayQueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
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
              AsyncValueBuilder(
                provider: appPlayerHandlerProvider,
                builder: (context, player, ref) {
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
                                initialId: playQueue.songs[playQueue.index].id,
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
              return _PlayQueueListView(playQueue: playQueue);
            },
          ),
        ),
      ],
    ),
  );
}

class _PlayQueueListView extends ConsumerStatefulWidget {
  const _PlayQueueListView({required this.playQueue});
  final PlayQueue playQueue;

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
      _setPositionListner();
    });
  }

  void _setPositionListner() async {
    final index = widget.playQueue.index;
    if (!_scrollController.hasClients) return;

    double targetOffset = index * (72.0 + 0.0);
    // 2. 核心：取 理论值 和 最大可滚动范围 之间的最小值
    // 确保 targetOffset 不会超过 maxScrollExtent
    double finalOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent - 23,
    );

    _scrollController.jumpTo(finalOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return AsyncStreamBuilder(
          provider: player.playingStream,
          loading: (_) => _buildListView(player: player, playing: false),
          builder: (_, playing) {
            return _buildListView(player: player, playing: playing);
          },
        );
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
