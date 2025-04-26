import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/pages/playlist/playlist_detail_page.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});
  @override
  State<StatefulWidget> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  _deletePlaylist(String? playlistId, WidgetRef ref) async {
    if (playlistId == null) return;
    final res = await ref
        .read(playlistsProvider.notifier)
        .deletePlaytlist(playlistId);
    if (res?.subsonicResponse?.status != 'ok') return;
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  _onDelete(PlaylistEntity playlist, WidgetRef ref) {
    if (playlist.id == null) return;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除'),
          content: Text('确定要删除歌单 ${playlist.name ?? ''} '),
          actions: [
            TextButton(
              onPressed: () => _deletePlaylist(playlist.id, ref),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 3, title: const Text('歌单')),
      body: AsyncValueBuilder(
        provider: playlistsProvider,
        builder: (p0, data, ref) {
          final playlist = data.subsonicResponse?.playlists?.playlist;
          if (playlist == null || playlist.isEmpty) {
            return const Center(child: NoData());
          }
          return ListView.separated(
            itemBuilder: (_, index) {
              final item = playlist[index];
              return ListTile(
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PlaylistDetailPage(playlistId: item.id),
                      ),
                    ),
                leading: Container(
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: ArtworkImage(id: item.coverArt),
                ),
                title: Text(item.name ?? '', overflow: TextOverflow.clip),
                subtitle: Text(
                  '${item.songCount}首 ${item.public == true ? '公开' : ''} ${item.comment ?? ''}',
                  overflow: TextOverflow.clip,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_outlined),
                  onPressed: () => _onDelete(item, ref),
                ),
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
