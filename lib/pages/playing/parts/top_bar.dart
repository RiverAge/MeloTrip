part of '../playing_page.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) {
    return CurrentSongBuilder(builder: (context, current, songs, index, ref) {
      return AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          scrolledUnderElevation: 0,
          title: Text(current?.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            AsyncValueBuilder(
                provider: songDetailProvider(current?.id),
                builder: (ctx, data, ref) {
                  final isStarred =
                      data.subsonicResponse?.song?.starred != null;
                  return IconButton(
                      onPressed: () async {
                        ref
                            .read(songFavoriteProvider.notifier)
                            .toggleFavorite(current?.id);
                      },
                      icon: Icon(
                          isStarred ? Icons.favorite : Icons.favorite_outline,
                          color: isStarred ? Colors.red : null));
                })
          ]);
    });
  }
}
