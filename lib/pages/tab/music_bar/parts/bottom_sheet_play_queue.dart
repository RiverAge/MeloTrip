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
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          AppLocalizations.of(context)!.confirmClearPlayQueue,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              final player = await ref.read(
                                appPlayerHandlerProvider.future,
                              );
                              await player?.setPlaylist(songs: []);
                              navigator.pop();
                            },
                            child: Text(AppLocalizations.of(context)!.confirm),
                          ),
                        ],
                      );
                    },
                  );
                  // ScaffoldMessenger.of(
                  //   context,
                  // ).showSnackBar(SnackBar(content: Text('122')));
                },
                icon: Icon(Icons.clear_all_outlined),
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
