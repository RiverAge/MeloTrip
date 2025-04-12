part of '../album_detail_page.dart';

class _AlbumInfo extends StatelessWidget {
  const _AlbumInfo({required this.album, required this.onUpdateRating});

  final AlbumEntity album;
  final void Function(int rating) onUpdateRating;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(left: 20),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  album.name ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      album.artist ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${album.songCount}首 ${album.year}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Rating(rating: album.userRating, onRating: onUpdateRating),
            ],
          ),
        ),
      ),
    );
  }
}
