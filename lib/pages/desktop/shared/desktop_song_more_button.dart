import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/similar_songs/similar_songs_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';

class DesktopSongMoreButton extends ConsumerWidget {
  const DesktopSongMoreButton({
    super.key,
    required this.song,
    this.iconSize = 18,
    this.iconColor,
  });

  final SongEntity? song;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveSong = song;
    final enabled = effectiveSong?.id?.trim().isNotEmpty ?? false;
    final foreground =
        iconColor ??
        colorScheme.onSurfaceVariant.withValues(alpha: enabled ? 0.78 : 0.32);

    return MenuAnchor(
      alignmentOffset: const Offset(-108, 4),
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          colorScheme.surfaceContainerHigh.withValues(alpha: 0.98),
        ),
        shadowColor: WidgetStateProperty.all(
          colorScheme.shadow.withValues(alpha: 0.16),
        ),
        elevation: WidgetStateProperty.all(8),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 4),
        ),
        minimumSize: WidgetStateProperty.all(const Size(148, 0)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.28),
            ),
          ),
        ),
      ),
      menuChildren: [
        _DesktopSongMenuItem(
          icon: Icons.hub_rounded,
          label: l10n.similarSongs,
          onPressed: () {
            final selectedSong = effectiveSong;
            if (selectedSong == null) return;
            _openSimilarSongs(context, selectedSong);
          },
        ),
        _DesktopSongMenuItem(
          icon: Icons.radio_rounded,
          label: l10n.similarRadio,
          onPressed: () {
            final selectedSong = effectiveSong;
            if (selectedSong == null) return;
            _startSimilarRadio(context, ref, selectedSong);
          },
        ),
      ],
      builder: (context, controller, _) {
        return Tooltip(
          message: '${l10n.similarSongs} / ${l10n.similarRadio}',
          child: MouseRegion(
            cursor: enabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: InkResponse(
              onTap: enabled
                  ? () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    }
                  : null,
              radius: 18,
              borderRadius: BorderRadius.circular(6),
              child: SizedBox.square(
                dimension: 34,
                child: Center(
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: iconSize,
                    color: foreground,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openSimilarSongs(BuildContext context, SongEntity song) {
    final songId = song.id?.trim();
    if (songId == null || songId.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            DesktopSimilarSongsPage(songId: songId, songTitle: song.title),
      ),
    );
  }

  Future<void> _startSimilarRadio(
    BuildContext context,
    WidgetRef ref,
    SongEntity song,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final player = await ref.read(appPlayerHandlerProvider.future);
    final radioQueueNotifier = ref.read(radioQueueProvider.notifier);
    await radioQueueNotifier.startRadio(song);

    // Check if seed song was not analyzed
    if (radioQueueNotifier.isSeedSongUnanalyzed) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.songNotAnalyzedForRadio)),
      );
      return;
    }

    final radioQueue = ref.read(radioQueueProvider);
    if (!context.mounted) return;
    if (radioQueue.isEmpty) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.noSongsFoundForRadio)),
      );
      return;
    }
    await player?.setPlaylist(
      songs: radioQueue,
      initialId: radioQueue.firstOrNull?.id,
    );
    await player?.play();
  }
}

class _DesktopSongMenuItem extends StatelessWidget {
  const _DesktopSongMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return MenuItemButton(
      onPressed: onPressed,
      leadingIcon: Icon(
        icon,
        size: 17,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.84),
      ),
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(132, 36)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12),
        ),
        foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
        overlayColor: WidgetStateProperty.all(
          colorScheme.primary.withValues(alpha: 0.08),
        ),
        textStyle: WidgetStateProperty.all(theme.textTheme.bodyMedium),
      ),
      child: Text(label, maxLines: 1, overflow: .ellipsis),
    );
  }
}
