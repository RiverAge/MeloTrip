import 'package:flutter/material.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/pages/smart_suggestion/smart_suggestion_page.dart';
import 'package:melo_trip/pages/search/search_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/smart_suggestion/smart_suggestion.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/endof_data.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/smart_suggestion.dart';
part 'parts/top_search_bar.dart';
part 'parts/albums.dart';
// part 'parts/song_controls.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageStage();
}

class _HomePageStage extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const _TopSeachBar()),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            _Albums(type: AlumsType.newest),
            _SmartSuggestion(),
            _Albums(type: AlumsType.random),
            EndofData(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
