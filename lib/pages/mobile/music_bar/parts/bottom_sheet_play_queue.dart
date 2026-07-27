part of 'music_bar.dart';

class _BottomSheetPlayQueue extends StatelessWidget {
  const _BottomSheetPlayQueue({
    this.searchStyle = PlayQueueSearchStyle.headerInline,
  });

  final PlayQueueSearchStyle searchStyle;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        GestureHint(),
        Expanded(
          child: PlayQueuePanel(
            variant: PlayQueuePanelVariant.mobile,
            onClose: () => Navigator.of(context).pop(),
            closeAfterClear: true,
            searchStyle: searchStyle,
          ),
        ),
      ],
    ),
  );
}
