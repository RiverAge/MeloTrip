part of '../song_control.dart';

class _SongTitle extends StatelessWidget {
  const _SongTitle({required this.song});
  final SongEntity song;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child:
            CurrentSongBuilder(builder: (context, current, songs, index, ref) {
          return AsyncStreamBuilder(
              provider: playingStreamProvider,
              builder: (_, playing, __) {
                final isCurrent = current?.id == song.id;
                final isCurrentPlaying = playing && isCurrent;
                return Row(children: [
                  Container(
                      width: 35,
                      margin: const EdgeInsets.only(right: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: ArtworkImage(id: song.id)),
                  if (isCurrentPlaying)
                    SizedBox(
                        width: 30,
                        child: Image.asset('images/playing.gif',
                            color: Theme.of(context).colorScheme.primary)),
                  Expanded(
                    child: Text(
                      song.title ?? '',
                      style: TextStyle(
                          fontSize: 18,
                          color: isCurrent
                              ? Theme.of(context).colorScheme.primary
                              : null),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return Rating(
                        onRating: (rating) {
                          ref
                              .read(songRatingProvider.notifier)
                              .updateRating(song.id, rating);
                        },
                        rating: song.userRating,
                      );
                    },
                  ),
                ]);
              });
        }));
  }
}
