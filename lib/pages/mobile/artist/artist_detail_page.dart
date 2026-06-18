import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/pages/mobile/album/album_detail_page.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/artist/similar_artists.dart';
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
      builder: (_, result, ref) {
        final artist = result.data?.subsonicResponse?.artist;
        if (artist == null) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.artist)),
            body: const Center(child: NoData()),
          );
        }
        final albums = artist.album;

        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                stretch: true,
                expandedHeight: width / 2,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  collapseMode: .parallax,
                  title: Text(artist.name ?? ''),
                  background: ArtworkImage(
                    id: artist.coverArt,
                    size: 5000,
                    fit: .cover,
                  ),
                ),
              ),
              if (albums != null && albums.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid.builder(
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
                                clipBehavior: .antiAlias,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: ArtworkImage(
                                  id: item.id,
                                  size: 200,
                                  fit: .cover,
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
                                    overflow: .ellipsis,
                                    style: const TextStyle(fontWeight: .bold),
                                  ),
                                  Text(
                                    '${item.songCount}${AppLocalizations.of(context)!.songCountUnit} ${_albumReleaseDateText(item)}',
                                    overflow: .ellipsis,
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
                ),
              // Similar Artists Section
              SliverToBoxAdapter(
                child: _SimilarArtistsSection(artistId: artist.id ?? artistId),
              ),
            ],
          ),
        );

        // return Scaffold(
        //   appBar: AppBar(elevation: 3, title: Text(artist.name ?? '')),
        //   body: albums == null || albums.isEmpty
        //       ? Center(child: Text(AppLocalizations.of(context)!.noDataFound))
        //       : GridView.builder(
        //           padding: const EdgeInsets.symmetric(
        //             vertical: 15,
        //             horizontal: 10,
        //           ),
        //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //             mainAxisSpacing: 20,
        //             crossAxisCount: 3,
        //             childAspectRatio: 0.85,
        //           ),
        //           itemCount: artist.album?.length,
        //           itemBuilder: (_, index) {
        //             final item = albums[index];
        //             return InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(
        //                   MaterialPageRoute(
        //                     builder: (_) => AlbumDetailPage(albumId: item.id),
        //                   ),
        //                 );
        //               },
        //               child: Column(
        //                 children: [
        //                   Expanded(
        //                     child: Container(
        //                       clipBehavior: .antiAlias,
        //                       decoration: const BoxDecoration(
        //                         borderRadius: BorderRadius.all(
        //                           Radius.circular(5),
        //                         ),
        //                       ),
        //                       child: ArtworkImage(
        //                         id: item.id,
        //                         size: 200,
        //                         fit: .cover,
        //                       ),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(
        //                       vertical: 2.0,
        //                       horizontal: 2,
        //                     ),
        //                     child: Column(
        //                       children: [
        //                         Text(
        //                           item.name ?? '',
        //                           overflow: .ellipsis,
        //                           style: const TextStyle(
        //                             fontWeight: .bold,
        //                           ),
        //                         ),
        //                         Text(
        //                           '${item.songCount}${AppLocalizations.of(context)!.songCountUnit} ${item.year != null ? ' ${item.year}' : ''}',
        //                           overflow: .ellipsis,
        //                           style: const TextStyle(fontSize: 10),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             );
        //           },
        //         ),
        // );
      },
    );
  }
}

String _albumReleaseDateText(AlbumEntity album) {
  final releaseDate = album.releaseDate;
  final year = releaseDate?.year;
  final month = releaseDate?.month;
  final day = releaseDate?.day;
  if (year != null && month != null && day != null) {
    return '$year-$month-$day';
  }
  if (year != null && month != null) {
    return '$year-$month';
  }
  if (year != null) {
    return '$year';
  }
  if (album.year != null) {
    return '${album.year}';
  }
  return '';
}

/// Similar Artists section widget.
///
/// Displays a horizontal list of similar artists.
/// Hidden when there are no similar artists to avoid cluttering the UI.
class _SimilarArtistsSection extends StatelessWidget {
  const _SimilarArtistsSection({required this.artistId});

  final String? artistId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AsyncValueBuilder(
      provider: similarArtistsProvider(artistId: artistId, count: 12),
      loading: (_, _) => const SizedBox.shrink(),
      builder: (context, artists, _) {
        // Hide section when no similar artists
        if (artists.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  l10n.similarArtists,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return _SimilarArtistCard(artist: artist);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Card widget for a single similar artist.
class _SimilarArtistCard extends StatelessWidget {
  const _SimilarArtistCard({required this.artist});

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArtistDetailPage(artistId: artist.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Artist cover
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: ArtworkImage(
                  id: artist.coverArt ?? artist.id,
                  size: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Artist name
            Text(
              artist.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
