import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/shared/player/playback_background.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';

part 'parts/section_header.dart';
part 'parts/desktop_hero.dart';
part 'parts/desktop_genre_section.dart';
part 'parts/desktop_album_section.dart';
part 'parts/desktop_recommendation_section.dart';

class DesktopHomePage extends ConsumerWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trailingSpacing = MediaQuery.paddingOf(context).bottom + 96;
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 20, 25, 30),
          sliver: SliverToBoxAdapter(child: _DesktopHero()),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 30),
          sliver: SliverToBoxAdapter(child: _DesktopGenreSection()),
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
          sliver: _DesktopRecommendationSection(title: l10n.guessYouLike),
        ),
        SliverToBoxAdapter(child: SizedBox(height: trailingSpacing)),
      ],
    );
  }
}
