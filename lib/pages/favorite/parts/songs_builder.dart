part of '../favorite_page.dart';

class _SongsBuilder extends StatelessWidget {
  const _SongsBuilder({required this.songs, required this.onToggleFavorite});
  final List<SongEntity>? songs;
  final void Function(SongEntity song) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final effectiveSongs = songs;
    return effectiveSongs == null
        ? const Center(child: NoData())
        : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 15),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: effectiveSongs.length,
            itemBuilder: (_, index) {
              final song = effectiveSongs[index];
              return ListTile(
                title: Text(song.title ?? '', overflow: TextOverflow.ellipsis),
                subtitle: Text(
                    overflow: TextOverflow.ellipsis,
                    '${song.album} - ${song.artist} - ${durationFormatter(song.duration)}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.5),
                        fontSize: 12)),
                leading: Container(
                    width: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: ArtworkImage(id: song.id)),
                trailing: IconButton(
                  onPressed: () => onToggleFavorite(song),
                  icon: const Icon(Icons.heart_broken),
                ),
              );
            },
          );
  }
}
