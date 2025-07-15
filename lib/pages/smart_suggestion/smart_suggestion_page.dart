import 'package:flutter/material.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/provider/smart_suggestion/smart_suggestion.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';

import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/endof_data.dart';

part 'parts/sliver_app_bar.dart';
part 'parts/sliver_background.dart';
part 'parts/list_item.dart';

class SmartSuggestionPage extends StatefulWidget {
  const SmartSuggestionPage({super.key});

  @override
  State<StatefulWidget> createState() => _SmartSuggestionPageState();
}

class _SmartSuggestionPageState extends State<SmartSuggestionPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: AsyncValueBuilder(
      provider: smartSuggestionProvider,
      builder: (ctx, data, _) {
        if (data.isEmpty) return NoData();
        return CustomScrollView(
          slivers: [
            _SliverAppBar(songs: data),
            SliverList.separated(
              separatorBuilder: (_, _) => const Divider(),
              itemCount: data.length,
              itemBuilder:
                  (ctx, idx) => Container(
                    margin: EdgeInsets.only(top: idx == 0 ? 10 : 0),
                    child: _ListItem(song: data[idx], index: idx),
                  ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: data.isNotEmpty ? const EndofData() : null,
              ),
            ),
          ],
        );
      },
    ),
  );
}
