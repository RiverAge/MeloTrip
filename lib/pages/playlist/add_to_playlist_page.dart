import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/playlist/add_playlist_page.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class AddToPlaylistPage extends StatefulWidget {
  const AddToPlaylistPage({super.key, required this.song});
  final SongEntity? song;
  @override
  State<StatefulWidget> createState() => _AddToPlaylistPageState();
}

class _AddToPlaylistPageState extends State<AddToPlaylistPage> {
  final _textFieldController = TextEditingController();
  PlaylistEntity? _current;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  _onAddToPlaylist(WidgetRef ref) async {
    final playlistId = _current?.id;
    final songId = widget.song?.id;
    if (playlistId == null || songId == null) return;
    final res = await Http.get<Map<String, dynamic>>(
      '/rest/updatePlaylist',
      queryParameters: {'playlistId': playlistId, 'songIdToAdd': songId},
    );
    final data = res?.data;
    if (data == null) return;
    final subsonicRes = SubsonicResponse.fromJson(data);
    if (subsonicRes.subsonicResponse?.status != 'ok') return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.songHasAddedToPlaylistToast(_current?.name ?? ''),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(AppLocalizations.of(context)!.addToPlaylist),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddPlaylistPage()),
              );
            },
            icon: const Icon(Icons.add),
          ),
          Consumer(
            builder: (context, ref, child) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child:
                    _current != null
                        ? IconButton(
                          onPressed: () => _onAddToPlaylist(ref),
                          icon: const Icon(Icons.check),
                        )
                        : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: AsyncValueBuilder(
        provider: playlistsProvider,
        builder: (p0, data, ref) {
          final playlist = data.subsonicResponse?.playlists?.playlist;
          if (playlist == null || playlist.isEmpty) return const NoData();
          return ListView.separated(
            itemBuilder: (_, index) {
              final item = playlist[index];
              return CheckboxListTile(
                onChanged: (value) {
                  setState(() {
                    _current = _current?.id == item.id ? null : item;
                  });
                },
                secondary: Container(
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: ArtworkImage(id: item.coverArt),
                ),
                title: Text(item.name ?? '', overflow: TextOverflow.clip),
                subtitle: Text(
                  '${item.songCount}${AppLocalizations.of(context)!.songCountUnit} ${item.comment ?? ''}',
                  overflow: TextOverflow.clip,
                ),
                value: _current?.id == item.id,
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: playlist.length,
          );
        },
      ),
    );
  }
}
