import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/pages/search_v2/search_page_v2.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/endof_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:google_fonts/google_fonts.dart';

part 'parts/top_search_bar.dart';
part 'parts/albums.dart';
part 'parts/for_you_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                l10n.listenNow,
                style: GoogleFonts.outfit(
                  fontWeight: .bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: 24,
                ),
              ),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const _TopSeachBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _Albums(
                type: .newest,
                title: l10n.recentAdded,
                layout: .grid,
                limit: 4,
              ),
              const SizedBox(height: 16),
              const _ForYouPlaceholder(),
              const SizedBox(height: 16),
              _Albums(
                type: .recent,
                title: l10n.rencentPlayed,
                layout: .tile,
                limit: 5,
              ),
              // const SizedBox(height: 16),
              const EndofData(),
              const SizedBox(height: 120),
            ]),
          ),
        ],
      ),
    );
  }
}
