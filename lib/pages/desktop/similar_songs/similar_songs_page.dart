import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/app_failure_message.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopSimilarSongsPage extends ConsumerWidget {
  const DesktopSimilarSongsPage({
    super.key,
    required this.songId,
    this.songTitle,
  });

  final String songId;
  final String? songTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final title = l10n.similarSongsTitle(songTitle ?? '');

    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
            child: Row(
              children: [
                IconButton(
                  onPressed: Navigator.of(context).canPop()
                      ? () => Navigator.of(context).pop()
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: l10n.cancel,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: .w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => _playAll(ref),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(l10n.play),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.32),
          ),
          Expanded(
            child: AsyncValueBuilder(
              provider: similarSongsProvider(songId: songId, count: 30),
              loading: (_, _) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
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
                    return _DesktopSimilarSongsList(songs: similarityResult.songs);
                  },
                  err: (failure) => Center(
                    child: Text(
                      resolveAppFailureMessage(l10n, failure: failure),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playAll(WidgetRef ref) async {
    final result = await ref.read(
      similarSongsProvider(songId: songId, count: 50).future,
    );
    await result.when(
      ok: (similarityResult) async {
        if (similarityResult.isEmpty) return;
        final player = await ref.read(appPlayerHandlerProvider.future);
        if (player == null) return;
        await player.setPlaylist(
          songs: similarityResult.songs,
          initialId: similarityResult.songs.firstOrNull?.id,
        );
        await player.play();
      },
      err: (_) async {},
    );
  }
}

class _DesktopSimilarSongsList extends StatelessWidget {
  const _DesktopSimilarSongsList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      itemCount: songs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return _DesktopSimilarSongRow(index: index + 1, song: songs[index]);
      },
    );
  }
}

class _DesktopSimilarSongRow extends ConsumerWidget {
  const _DesktopSimilarSongRow({required this.index, required this.song});

  final int index;
  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final subtitle = _joinNonEmpty([
      song.displayArtist ?? song.artist,
      song.album,
    ]);

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () async {
        final player = await ref.read(appPlayerHandlerProvider.future);
        await player?.insertAndPlay(song);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '$index',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ArtworkImage(
                id: song.coverArt ?? song.albumId ?? song.id,
                width: 44,
                height: 44,
                size: 180,
                fit: .cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    song.title ?? l10n.noTitle,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: .w700,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.78,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _formatDuration(song.duration),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  String _joinNonEmpty(List<String?> values) {
    return values
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .join(' - ');
  }
}
