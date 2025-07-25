part of 'music_bar.dart';

class _BottomSheetTitle extends StatelessWidget {
  const _BottomSheetTitle();
  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder:
          (context, playQueue, _) => Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.playQueue,
              style: const TextStyle(fontSize: 17),
              children: [
                TextSpan(
                  text: '（${playQueue.songs.length}）',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
