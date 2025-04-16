import 'package:flutter/material.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class ArtistDetailPage extends StatelessWidget {
  const ArtistDetailPage({super.key, required this.artistId});
  final String? artistId;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: artistDetailProvider(artistId),
      builder: (_, data, ref) {
        final artist = data.subsonicResponse?.artist;
        if (artist == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('艺术家')),
            body: const Center(child: NoData()),
          );
        }
        final albums = artist.album;
        return Scaffold(
          appBar: AppBar(elevation: 3, title: Text(artist.name ?? '')),
          body:
              albums == null || albums.isEmpty
                  ? const Center(child: Text('暂无专辑'))
                  : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: artist.album?.length,
                    itemBuilder: (_, index) {
                      final item = albums[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlbumDetailPage(albumId: item.id),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: ArtworkImage(
                                  id: item.id,
                                  size: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 2,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    item.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${item.songCount}首 ${item.year}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
