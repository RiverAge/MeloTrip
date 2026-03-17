import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopArtistDetailPage extends ConsumerWidget {
  const DesktopArtistDetailPage({super.key, required this.artistId});

  final String? artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AsyncValueBuilder(
        provider: artistDetailProvider(artistId),
        builder: (context, data, ref) {
          final artist = data.subsonicResponse?.artist;
          if (artist == null) {
            return const NoData();
          }
          return _ArtistDetailContent(artist: artist);
        },
      ),
    );
  }
}

class _ArtistDetailContent extends StatelessWidget {
  const _ArtistDetailContent({required this.artist});

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final albums = artist.album ?? const <AlbumEntity>[];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          expandedHeight: 320,
          backgroundColor: theme.colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(artist.name ?? '-'),
            collapseMode: CollapseMode.pin,
            background: Stack(
              fit: StackFit.expand,
              children: [
                ArtworkImage(
                  id: artist.coverArt,
                  size: 1600,
                  fit: BoxFit.cover,
                ),
                // BackdropFilter(
                //   filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                //   child: ColoredBox(
                //     color: theme.colorScheme.surface.withValues(alpha: 0.5),
                //   ),
                // ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.surface.withValues(alpha: 0.12),
                        theme.colorScheme.surface.withValues(alpha: 0.02),
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // _ArtistArtwork(coverArtId: artist.coverArt),
                        // const SizedBox(width: 24),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       const SizedBox(height: 16),
                        //       Wrap(
                        //         spacing: 16,
                        //         runSpacing: 8,
                        //         children: [
                        //           _MetricChip(
                        //             label:
                        //                 '${albums.length} ${l10n.album.toLowerCase()}',
                        //           ),
                        //           if (artist.albumCount != null)
                        //             _MetricChip(
                        //               label:
                        //                   '${artist.albumCount} ${l10n.albumCount}',
                        //             ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (albums.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: NoData()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return DesktopAlbumCard(
                  album: albums[index],
                  showReleaseDate: true,
                );
              }, childCount: albums.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
                childAspectRatio: 0.75,
              ),
            ),
          ),
      ],
    );
  }
}
