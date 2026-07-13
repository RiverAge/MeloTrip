part of '../playlist_detail_page.dart';

class _PlaylistActionBar extends StatelessWidget {
  const _PlaylistActionBar({required this.playlist});

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSongs = playlist.entry != null && playlist.entry!.isNotEmpty;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          children: [
            // 信息标签 - 靠左
            _PlaylistMetaInfo(playlist: playlist),
            const Spacer(),
            // 随机播放按钮
            _SecondaryButton(
              icon: Icons.shuffle_rounded,
              label: l10n.shuffle,
              onPressed: hasSongs ? () => _shufflePlay(context) : null,
            ),
            const SizedBox(width: 10),
            // 播放全部按钮 - 在最右边
            _PlayButton(
              icon: Icons.play_arrow_rounded,
              label: l10n.play,
              onPressed: hasSongs ? () => _playAll(context) : null,
            ),
          ],
        ),
      ),
    );
  }

  void _playAll(BuildContext context) {
    final effectiveSongs = playlist.entry;
    if (effectiveSongs == null || effectiveSongs.isEmpty) return;

    final container = ProviderScope.containerOf(context);
    final player = container.read(appPlayerHandlerProvider).value;
    if (player == null) return;

    // 追加到当前播放队列
    player.setPlaylist(
      songs: [...effectiveSongs, ...player.playQueue.songs],
      initialId: effectiveSongs.firstOrNull?.id,
    );
    player.play();
  }

  void _shufflePlay(BuildContext context) {
    final effectiveSongs = playlist.entry;
    if (effectiveSongs == null || effectiveSongs.isEmpty) return;

    final container = ProviderScope.containerOf(context);
    final player = container.read(appPlayerHandlerProvider).value;
    if (player == null) return;

    // 打乱后追加到当前播放队列
    final shuffled = [...effectiveSongs]..shuffle();
    player.setPlaylist(
      songs: [...shuffled, ...player.playQueue.songs],
      initialId: shuffled.firstOrNull?.id,
    );
    player.play();
  }
}

/// 信息标签 - 靠右显示，缩小文字
class _PlaylistMetaInfo extends StatelessWidget {
  const _PlaylistMetaInfo({required this.playlist});

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 歌曲数量
          Icon(
            Icons.music_note_outlined,
            size: 10,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              '${playlist.songCount ?? 0} ${l10n.songCountUnit}',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (playlist.entry != null && playlist.entry!.isNotEmpty) ...[
            const SizedBox(width: 6),
            // 分隔点
            Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 6),
            // 总时长
            Icon(
              Icons.schedule_outlined,
              size: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                _formatDuration(playlist.entry),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(List<dynamic>? songs) {
    if (songs == null || songs.isEmpty) return '0:00';
    final totalSeconds = songs.fold<int>(
      0,
      (sum, song) => sum + (((song as dynamic).duration ?? 0) as int),
    );
    return durationFormatter(totalSeconds);
  }
}

/// 主播放按钮 - 胶囊形状，带阴影
class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

/// 次要按钮 - 圆角矩形
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        foregroundColor: theme.colorScheme.onSurface,
      ),
    );
  }
}
