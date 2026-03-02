part of '../search_page.dart';

class _SongItem extends StatelessWidget {
  final SongEntity song;

  const _SongItem({required this.song});

  @override
  Widget build(BuildContext context) => AsyncValueBuilder(
    provider: appPlayerHandlerProvider,
    builder: (context, player, ref) {
      return ListTile(
        onTap: () async {
          final navigator = Navigator.of(context);
          await player.playOrToggleFromSongTap(song);
          navigator.pop();
        },
        leading: Container(
          height: 50,
          width: 50,
          clipBehavior: .antiAlias,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: ArtworkImage(id: song.id, fit: .cover),
        ),
        title: Text(
          '${song.title}',
          overflow: .ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: .bold),
        ),
        subtitle: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  _Tag(text: '${song.suffix}'),
                  _Tag(text: '${song.bitRate.toString()}k'),
                  _Tag(text: durationFormatter(song.duration ?? 0)),
                ],
              ),
            ),
            Text(
              '《${song.album}》- ${song.artist}',
              overflow: .ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => showSongControlSheet(context, song.id),
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    },
  );
}
