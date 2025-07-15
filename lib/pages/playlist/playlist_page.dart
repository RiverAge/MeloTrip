import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
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

  void _deletePlaylist(String? playlistId, WidgetRef ref) async {
    if (playlistId == null) return;
    final res = await ref
        .read(playlistsProvider.notifier)
        .deletePlaytlist(playlistId);
    if (res?.subsonicResponse?.status != 'ok') return;
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _onDelete(PlaylistEntity playlist, WidgetRef ref) {
    if (playlist.id != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.delete),
            content: Text(
              AppLocalizations.of(
                context,
              )!.playlistDeleteConfirmation(playlist.name ?? ''),
            ),
            actions: [
              TextButton(
                onPressed: () => _deletePlaylist(playlist.id, ref),
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(AppLocalizations.of(context)!.myPlaylist),
      ),
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
                  '${item.songCount}${AppLocalizations.of(context)!.songCountUnit} ${item.public == true ? AppLocalizations.of(context)!.playlistIsPublic : ''} ${item.comment ?? ''}',
                  overflow: TextOverflow.clip,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_outlined),
                  onPressed: () => _onDelete(item, ref),
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(),
            itemCount: playlist.length,
          );
        },
      ),
    );
  }
}
