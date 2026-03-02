part of '../album_detail_page.dart';

class _AlbumInfo extends StatelessWidget {
  const _AlbumInfo({required this.album, required this.onUpdateRating});

  final AlbumEntity album;
  final void Function(int rating) onUpdateRating;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        children: [
          Text(album.name ?? '', style: TextStyle(fontWeight: .bold)),
          SizedBox(height: 4),
          Text(
            album.artist ?? '',
            overflow: .ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 4),
          Rating(rating: album.userRating, onRating: onUpdateRating),
        ],
      ),
    );
    // margin: const EdgeInsets.only(left: 20),
    // child: DefaultTextStyle(
    // style: const TextStyle(fontSize: 15),
    // child: Column(
    //   crossAxisAlignment: .start,
    //   mainAxisAlignment: .spaceAround,
    //   children: [
    //     Expanded(
    //       child: Text(
    //         album.name ?? '',
    //         style: TextStyle(
    //           color: Theme.of(context).colorScheme.onSurface,
    //           fontWeight: .bold,
    //         ),
    //       ),
    //     ),
    //     Row(
    //       children: [
    //         Expanded(
    //           child: Text(
    //             album.artist ?? '',
    //             overflow: .ellipsis,
    //             maxLines: 1,
    //             style: TextStyle(
    //               color: Theme.of(context).colorScheme.onSurface,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     Text(
    //       '${album.songCount}${AppLocalizations.of(context)!.songCountUnit} ${album.year}',
    //       style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    //     ),
    //     Rating(rating: album.userRating, onRating: onUpdateRating),
    //   ],
    // ),
    // ),
  }
}
