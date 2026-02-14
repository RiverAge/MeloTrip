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
    _setPositionListner();
  }

  void _setPositionListner() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    final index = player.playQueue.index;
    if (!_scrollController.hasClients) return;

    double targetOffset = index * (72.0 + 0.0);
    // 2. 核心：取 理论值 和 最大可滚动范围 之间的最小值
    // 确保 targetOffset 不会超过 maxScrollExtent
    double finalOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent - 50,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        finalOffset,
        // duration: Duration(seconds: 1),
        // curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.symmetric(horizontal: 8),
    controller: _scrollController,
    itemCount: widget.playQueue.songs.length,
    separatorBuilder: (context, index) => const Divider(height: 0),
    itemBuilder: (context, idx) {
      return _BottomSheetItem(
        songs: widget.playQueue.songs,
        currentPlayingIndex: widget.playQueue.index,
        index: idx,
      );
    },
  );
}
