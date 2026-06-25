import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

/// Page for generating a sonic path between two songs.
///
/// Uses the findSonicPath endpoint from AudioMuse-AI plugin to create
/// an acoustic transition path from a start song to an end song.
///
/// IMPORTANT: This uses findSonicPath, NOT getSimilarSongs2.
class SonicPathPage extends StatefulWidget {
  const SonicPathPage({super.key});

  @override
  State<SonicPathPage> createState() => _SonicPathPageState();
}

class _SonicPathPageState extends State<SonicPathPage> {
  SongEntity? _startSong;
  SongEntity? _endSong;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sonicPathTitle)),
      body: Column(
        children: [
          // Start song selector
          _SongSelector(
            label: l10n.fromSong,
            hint: l10n.selectStartSong,
            selectedSong: _startSong,
            onSongSelected: (song) => setState(() => _startSong = song),
          ),
          const Divider(),
          // End song selector
          _SongSelector(
            label: l10n.toSong,
            hint: l10n.selectEndSong,
            selectedSong: _endSong,
            onSongSelected: (song) => setState(() => _endSong = song),
          ),
          const Divider(),
          // Generate button
          if (_startSong != null && _endSong != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _generateAndPlayPath(context),
                icon: const Icon(Icons.route),
                label: Text(l10n.generatePath),
              ),
            ),
          // Path result
          if (_startSong != null && _endSong != null)
            Expanded(
              child: _PathResult(
                startSongId: _startSong!.id!,
                endSongId: _endSong!.id!,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _generateAndPlayPath(BuildContext context) async {
    if (_startSong == null || _endSong == null) return;

    final ref = ProviderScope.containerOf(context);
    final result = await ref.read(
      sonicPathProvider(
        startSongId: _startSong!.id!,
        endSongId: _endSong!.id!,
        count: 20,
      ).future,
    );

    result.when(
      ok: (similarityResult) async {
        if (similarityResult.isEmpty) return;
        final player = await ref.read(appPlayerHandlerProvider.future);
        if (player != null) {
          // Play the path: start song + path songs + end song
          final allSongs = [_startSong!, ...similarityResult.songs];
          if (similarityResult.songs.last.id != _endSong!.id) {
            allSongs.add(_endSong!);
          }
          await player.setPlaylist(songs: allSongs, initialId: _startSong!.id);
          await player.play();
        }
      },
      err: (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message)));
        }
      },
    );
  }
}

/// Widget for selecting a song (start or end of path).
class _SongSelector extends StatelessWidget {
  const _SongSelector({
    required this.label,
    required this.hint,
    required this.selectedSong,
    required this.onSongSelected,
  });

  final String label;
  final String hint;
  final SongEntity? selectedSong;
  final void Function(SongEntity) onSongSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: selectedSong != null
          ? ArtworkImage(
              id: selectedSong!.coverArt,
              size: 48,
              fit: BoxFit.cover,
            )
          : const CircleAvatar(child: Icon(Icons.music_note)),
      title: Text(label),
      subtitle: Text(
        selectedSong?.title ?? hint,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _showSongSearch(context),
      ),
    );
  }

  void _showSongSearch(BuildContext context) {
    // For now, show a simple dialog to enter song ID
    // In a full implementation, this would open a song search page
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(label),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint, labelText: 'Song ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Create a minimal SongEntity with the ID
                final song = SongEntity(id: controller.text);
                onSongSelected(song);
                Navigator.pop(context);
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }
}

/// Widget displaying the generated sonic path.
class _PathResult extends ConsumerWidget {
  const _PathResult({required this.startSongId, required this.endSongId});

  final String startSongId;
  final String endSongId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AsyncValueBuilder(
      provider: sonicPathProvider(
        startSongId: startSongId,
        endSongId: endSongId,
        count: 15,
      ),
      builder: (context, result, ref) {
        return result.when(
          ok: (similarityResult) {
            if (similarityResult.isUnanalyzed) {
              return Center(child: Text(l10n.songNotAnalyzed));
            }
            if (similarityResult.isEmpty) {
              return Center(child: Text(l10n.noSimilarSongsFound));
            }
            return ListView.builder(
              itemCount: similarityResult.songs.length,
              itemBuilder: (context, index) {
                final song = similarityResult.songs[index];
                return ListTile(
                  leading: ArtworkImage(
                    id: song.coverArt,
                    size: 48,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    song.title ?? l10n.noTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${song.artist ?? ''} • ${song.album ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text('${index + 1}'),
                  onTap: () async {
                    final player = await ref.read(
                      appPlayerHandlerProvider.future,
                    );
                    if (player != null) {
                      await player.insertAndPlay(song);
                    }
                  },
                );
              },
            );
          },
          err: (error) => Center(child: Text(error.message)),
        );
      },
    );
  }
}
