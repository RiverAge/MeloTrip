import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/section_header.dart';
part 'parts/desktop_hero.dart';
part 'parts/desktop_genre_section.dart';
part 'parts/desktop_album_section.dart';
part 'parts/desktop_album_card.dart';

class DesktopHomePage extends ConsumerWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
          sliver: SliverToBoxAdapter(child: _DesktopHero()),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
          sliver: SliverToBoxAdapter(child: _DesktopGenreSection()),
        ),
        _DesktopAlbumSection(title: l10n.rencentPlayed, type: .recent),
        _DesktopAlbumSection(title: l10n.recentAdded, type: .newest),
        _DesktopAlbumSection(title: l10n.randomAlbum, type: .random),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}
