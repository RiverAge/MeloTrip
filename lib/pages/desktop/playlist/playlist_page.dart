import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopPlaylistsPage extends ConsumerWidget {
  const DesktopPlaylistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.myPlaylist),
      ),
      body: AsyncValueBuilder(
        provider: playlistsProvider,
        loading: (_, _) => const Center(child: CircularProgressIndicator()),
        empty: (_, _) => const NoData(),
        builder: (context, data, _) {
          final playlists = data.subsonicResponse?.playlists?.playlist ?? [];
          if (playlists.isEmpty) return const NoData();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            itemCount: playlists.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final it = playlists[index];
              return Material(
                borderRadius: BorderRadius.circular(10),
                color: theme.colorScheme.surfaceContainerHigh.withValues(
                  alpha: .55,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DesktopPlaylistDetailPage(playlistId: it.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ArtworkImage(
                            id: it.id,
                            width: 54,
                            height: 54,
                            fit: .cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(it.name ?? '-'),
                              const SizedBox(height: 4),
                              Text(
                                '${it.songCount ?? 0} ${l10n.songCountUnit}',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
