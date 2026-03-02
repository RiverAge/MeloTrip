part of '../tab_page.dart';

class _DesktopWindowBar extends StatelessWidget {
  const _DesktopWindowBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: .35),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.music_note_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PlayQueueBuilder(
              loadingBuilder: (_, _) => const SizedBox.shrink(),
              builder: (_, queue, _) {
                final current =
                    queue.index < 0 || queue.index >= queue.songs.length
                    ? null
                    : queue.songs[queue.index];
                return Text(
                  current == null
                      ? l10n.listenNow
                      : '${current.title ?? '-'} - ${current.displayArtist ?? '-'}',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          const Icon(Icons.remove, size: 14),
          const SizedBox(width: 10),
          const Icon(Icons.crop_square_rounded, size: 12),
          const SizedBox(width: 10),
          const Icon(Icons.close_rounded, size: 14),
        ],
      ),
    );
  }
}
