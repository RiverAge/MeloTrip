part of 'music_bar.dart';

class _BottomSheetPlayQueue extends ConsumerStatefulWidget {
  const _BottomSheetPlayQueue();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetPlayQueueState();
}

class _BottomSheetPlayQueueState extends ConsumerState<_BottomSheetPlayQueue> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        72.00 * index,
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              _BottomSheetActionsMode(),
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
                      final api = await ref.read(apiProvider.future);
                      await api.get('/rest/savePlayQueue');
                      // 不能在main中监听，因为player初始化的时候会有playlist的stream，他会返回空
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
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 8),
                controller: _scrollController,
                itemCount: playQueue.songs.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, idx) {
                  return _BottomSheetItem(
                    songs: playQueue.songs,
                    currentPlayingIndex: playQueue.index,
                    index: idx,
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
