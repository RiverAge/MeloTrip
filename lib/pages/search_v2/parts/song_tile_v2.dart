part of '../search_page_v2.dart';

class _SongTileV2 extends ConsumerWidget with SongControl {
  const _SongTileV2({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder<AppPlayer>(
      provider: appPlayerHandlerProvider,
      builder: (context, player, ref) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: ArtworkImage(id: song.coverArt, fit: .cover),
              ),
            ),
            title: Text(
              song.title ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: .w600),
            ),
            subtitle: Text(
              '${song.artist ?? ""}${song.album != null ? " · ${song.album}" : ""}',
              maxLines: 1,
              overflow: .ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            trailing: IconButton(
              onPressed: () => showSongControlSheet(context, song.id),
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            onTap: () async {
              final playQueue = player.playQueue;
              final currentSong =
                  playQueue.index >= playQueue.songs.length
                      ? null
                      : playQueue.songs[playQueue.index];
              if (currentSong?.id == song.id) {
                await player.playOrPause();
              } else {
                await player.insertAndPlay(song);
              }
            },
          ),
        );
      },
    );
  }
}
