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
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: _BottomSheetTitle(),
        actions: [_BottomSheetActionsMode()],
        centerTitle: false,
        elevation: 0.3, // 控制投影效果的高度
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        shadowColor: Theme.of(context).colorScheme.surfaceTint,
        automaticallyImplyLeading: false,
      ),
      body: PlayQueueBuilder(
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
  );
}
