import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/fragment/artwork_image/artwork_image.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/rec_today/rec_today.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/svc/app_player_handler.dart';

import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/endof_data.dart';

part 'parts/sliver_app_bar.dart';
part 'parts/sliver_background.dart';
part 'parts/list_item.dart';

class RecommendTodayPage extends StatefulWidget {
  const RecommendTodayPage({super.key});

  @override
  State<StatefulWidget> createState() => _RecommendTodayPageState();
}

class _RecommendTodayPageState extends State<RecommendTodayPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: AsyncValueBuilder(
            provider: recTodayProvider,
            builder: (ctx, data, _) {
              return CustomScrollView(
                slivers: [
                  _SliverAppBar(songs: data),
                  SliverList.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: data.length,
                    itemBuilder: (ctx, idx) => Container(
                        margin: EdgeInsets.only(top: idx == 0 ? 10 : 0),
                        child: _ListItem(song: data[idx], index: idx)),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      child: data.isNotEmpty ? const EndofData() : null,
                    ),
                  ),
                ],
              );
            }),
      );
}
