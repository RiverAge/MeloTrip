part of 'music_bar.dart';

class _BottomSheetControls extends StatelessWidget {
  const _BottomSheetControls();
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    //   return AsyncStreamBuilder(
    //     provider: playlistModeStreamProvider,
    //     builder: (_, playlistMode, __) {
    //       return IconButton(
    //         onPressed:
    //             playlistMode == PlaylistMode.single
    //                 ? null
    //                 : () async {
    //                   final hanlder = await AppPlayerHandler.instance;
    //                   final player = hanlder.player;
    //                   await player.setShuffleModeEnabled(
    //                     !player.shuffleModeEnabled,
    //                   );
    //                 },
    //         icon: AsyncStreamBuilder(
    //           provider: shuffleModeEnabledStreamProvider,
    //           builder: (_, mode, __) {
    //             return mode
    //                 ? Icon(
    //                   Icons.shuffle_on_outlined,
    //                   color: Theme.of(context).colorScheme.primary,
    //                 )
    //                 : const Icon(Icons.shuffle_outlined);
    //           },
    //         ),
    //       );
    //     },
    //   );
  }
}
