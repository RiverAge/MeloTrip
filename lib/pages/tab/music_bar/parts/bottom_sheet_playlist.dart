part of 'music_bar.dart';

class _BottomSheetPlaylist extends StatefulWidget {
  const _BottomSheetPlaylist();

  @override
  State<StatefulWidget> createState() => _BottomSheetPlaylistState();
}

class _BottomSheetPlaylistState extends State<_BottomSheetPlaylist> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setPosition();
  }

  _setPosition() async {
    final hanlder = await AppPlayerHandler.instance;
    final player = hanlder.player;
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
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 2),
          child: Row(
            children: [
              Expanded(child: _BottomSheetTitle()),
              _BottomSheetActionsMode(),
            ],
          ),
        ),
        Expanded(
          child: PlayQueueBuilder(
            builder: (_, playQueue, __) {
              if (playQueue.songs.isEmpty) {
                return NoData();
              }
              return ListView.separated(
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
