import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/artist/similar_artists.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopArtistDetailPage extends ConsumerWidget {
  const DesktopArtistDetailPage({super.key, required this.artistId});

  final String? artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: AsyncValueBuilder(
        provider: artistDetailProvider(artistId),
        builder: (context, result, ref) {
          final artist = result.data?.subsonicResponse?.artist;
          if (artist == null) {
            return const NoData();
          }
          return _ArtistDetailContent(artist: artist, artistId: artistId);
        },
      ),
    );
  }
}

class _ArtistDetailContent extends StatelessWidget {
  const _ArtistDetailContent({required this.artist, required this.artistId});

  final ArtistEntity artist;
  final String? artistId;

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
        // Similar Artists Section
        SliverToBoxAdapter(
          child: _DesktopSimilarArtistsSection(artistId: artist.id ?? artistId),
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

/// Similar Artists section widget for desktop.
///
/// Displays a horizontal list of similar artists.
/// Hidden when there are no similar artists to avoid cluttering the UI.
class _DesktopSimilarArtistsSection extends StatelessWidget {
  const _DesktopSimilarArtistsSection({required this.artistId});

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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return _DesktopSimilarArtistCard(artist: artist);
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

/// Card widget for a single similar artist on desktop.
class _DesktopSimilarArtistCard extends StatelessWidget {
  const _DesktopSimilarArtistCard({required this.artist});

  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DesktopArtistDetailPage(artistId: artist.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Artist cover
            Container(
              width: 90,
              height: 90,
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
