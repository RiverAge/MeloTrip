part of 'music_bar.dart';

class _BottomSheetPlaylist extends StatefulWidget {
  const _BottomSheetPlaylist();

  @override
  State<StatefulWidget> createState() => _BottomSheetPlaylistState();
}

class _BottomSheetPlaylistState extends State<_BottomSheetPlaylist> {
  late final ScrollController _scrollController;
  final GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setPosition();
  }

  _setPosition() async {
    final hanlder = await AppPlayerHandler.instance;
    final player = hanlder.player;
    final index = player.currentIndex ?? 0;
    _scrollController = ScrollController(initialScrollOffset: 64.3 * index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_BottomSheetTitle(), _BottomSheetControls()])),
        const Divider(height: 0),
        Expanded(
            child: CurrentSongBuilder(builder: (_, current, songs, index, __) {
          return ListView.separated(
              itemCount: songs.length,
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, idx) {
                return _BottomSheetItem(
                  songs: songs,
                  currentPlayingIndex: index,
                  index: idx,
                );
              });

          // return AnimatedList(
          //     key: animatedListStateKey,
          //     initialItemCount: songs.length,
          //     controller: _scrollController,
          //     itemBuilder: (context, idx, animation) {
          //       return Column(
          //         children: [
          //           _BottomSheetItem(
          //               songs: songs,
          //               currentPlayingIndex: index,
          //               index: idx,
          //               onRemove: (index) {
          //                 animatedListStateKey.currentState?.removeItem(idx,
          //                     (ct, animation) {
          //                   return FadeTransition(
          //                     opacity: CurvedAnimation(
          //                       parent: animation,
          //                       //让透明度变化的更快一些
          //                       curve: const Interval(0.5, 1.0),
          //                     ),
          //                     // 不断缩小列表项的高度
          //                     child: SizeTransition(
          //                       sizeFactor: animation,
          //                       child: _BottomSheetItem(
          //                         songs: songs,
          //                         currentPlayingIndex: -1,
          //                         index: idx,
          //                       ),
          //                     ),
          //                   );
          //                 });
          //               }),
          //           songs.length - 1 == idx
          //               ? const SizedBox.shrink()
          //               : const Divider(height: 0)
          //         ],
          //       );
          //     });
        })),
      ]);
}
