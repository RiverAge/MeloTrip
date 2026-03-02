part of '../album_detail_page.dart';

class ListItemHead extends StatelessWidget {
  const ListItemHead({
    super.key,
    required this.album,
    required this.onUpdateRating,
  });
  final AlbumEntity album;
  final void Function(int rating) onUpdateRating;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Column(
            children: [
              Row(
                children: [
                  _AlbumCover(album: album),
                  SizedBox(width: 10),
                  _AlbumInfo(album: album, onUpdateRating: onUpdateRating),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${album.songCount}',
                        style: TextStyle(fontWeight: .bold),
                      ),
                      Text(
                        AppLocalizations.of(context)!.albumHeaderSongs,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        durationFormatter(album.duration),
                        style: TextStyle(fontWeight: .bold),
                      ),
                      Text(
                        AppLocalizations.of(context)!.albumHeaderDuration,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${album.releaseDate?.year != null ? '${album.releaseDate?.year}${album.releaseDate?.month != null ? '-${album.releaseDate?.month}' : ''}${album.releaseDate?.day != null ? '-${album.releaseDate?.day}' : ''}' : album.year}',
                        style: TextStyle(fontWeight: .bold),
                      ),
                      Text(
                        AppLocalizations.of(context)!.albumHeaderReleaseDate,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
