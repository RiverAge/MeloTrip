import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/edit_playlist_builder.dart';

class EditPlaylistPage extends StatelessWidget {
  const EditPlaylistPage({super.key, this.playlistId});

  final String? playlistId;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
        provider: playlistDetailProvider(playlistId),
        builder: (context, data, ref) {
          final playlist = data.subsonicResponse?.playlist;
          if (playlist == null) return const Center(child: NoData());
          return _EditPlaylistBuilder(
            playlist: playlist,
          );
        });
  }
}
