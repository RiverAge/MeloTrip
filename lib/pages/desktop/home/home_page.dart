import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_recommendation_shelf.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_shelf_header.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/pages/shared/player/playback_background.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/shimmer.dart';

part 'parts/desktop_hero.dart';
part 'parts/desktop_album_section.dart';

class DesktopHomePage extends ConsumerStatefulWidget {
  const DesktopHomePage({super.key});

  @override
  ConsumerState<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends ConsumerState<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final trailingSpacing = MediaQuery.paddingOf(context).bottom + 96;

    final forYou = ref.watch(forYouRecommendationsProvider);
    final forYouSongs = forYou.asData?.value ?? const <SongEntity>[];
    final forYouRefreshing = forYou.isLoading && forYouSongs.isNotEmpty;

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 20, 25, 30),
          sliver: SliverToBoxAdapter(child: _DesktopHero()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
          sliver: _DesktopAlbumSection(
            title: l10n.rencentPlayed,
            type: .recent,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
          sliver: _DesktopAlbumSection(title: l10n.recentAdded, type: .newest),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
          sliver: SliverToBoxAdapter(
            child: DesktopRecommendationShelf(
              title: l10n.guessYouLike,
              icon: Icons.auto_awesome_rounded,
              songs: forYou,
              isRefreshing: forYouRefreshing,
              onRefresh: forYouSongs.isEmpty
                  ? null
                  : () => ref
                      .read(forYouRecommendationRefreshProvider.notifier)
                      .requestRefresh(forYouSongs),
              onPlayAll: () => _playAll(forYouSongs),
              showScrollArrows: true,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: trailingSpacing)),
      ],
    );
  }

  Future<void> _playAll(List<SongEntity> songs) async {
    if (songs.isEmpty) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player?.play();
  }
}
