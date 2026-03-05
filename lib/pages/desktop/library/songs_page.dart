import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';

class DesktopSongsPage extends ConsumerWidget {
  const DesktopSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(
            title: l10n.song,
            count: 22226, // Mock count or fetch from provider
          ),
          _Toolbar(),
          Expanded(
            child: AsyncValueBuilder(
              provider: randomSongsProvider,
              builder: (context, data, ref) {
                final songs = data.subsonicResponse?.randomSongs?.song ?? [];
                return _TrackTable(songs: songs);
              },
            ),
          ),
        ],
      ),
    );
  }
}

final randomSongsProvider = FutureProvider<SubsonicResponse>((ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/getRandomSongs',
    queryParameters: {'size': 100},
  );
  return SubsonicResponse.fromJson(res.data!);
});

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: .w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _ToolbarButton(label: '名称', icon: Icons.sort_by_alpha_rounded),
          const SizedBox(width: 16),
          _ToolbarIcon(icon: Icons.filter_list_rounded),
          const SizedBox(width: 16),
          _ToolbarIcon(icon: Icons.refresh_rounded),
          const Spacer(),
          _ToolbarIcon(icon: Icons.grid_view_rounded),
          const SizedBox(width: 8),
          _ToolbarIcon(icon: Icons.tune_rounded),
        ],
      ),
    );
  }
}

class _TrackTable extends StatelessWidget {
  const _TrackTable({required this.songs});
  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 30, child: Text('#', style: _headerStyle)),
              const Expanded(flex: 4, child: Text('TITLE', style: _headerStyle)),
              const SizedBox(width: 60, child: Icon(Icons.access_time_rounded, size: 14, color: Colors.grey)),
              const Expanded(flex: 3, child: Text('ALBUM', style: _headerStyle)),
              const Expanded(flex: 2, child: Text('GENRE', style: _headerStyle)),
              const SizedBox(width: 60, child: Text('YEAR', style: _headerStyle)),
              const SizedBox(width: 30),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return _TrackRow(index: index + 1, song: song);
            },
          ),
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: .bold,
    color: Colors.grey,
    letterSpacing: 1.2,
  );
}

class _TrackRow extends ConsumerWidget {
  const _TrackRow({required this.index, required this.song});
  final int index;
  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final player = await ref.read(appPlayerHandlerProvider.future);
        await player?.insertAndPlay(song);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text('$index', style: theme.textTheme.bodySmall),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ArtworkImage(id: song.id, size: 80, width: 40, height: 40),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          song.title ?? '-',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        Text(
                          song.artist ?? '-',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(_formatDuration(song.duration), style: theme.textTheme.bodySmall),
            ),
            Expanded(
              flex: 3,
              child: Text(
                song.album ?? '-',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                song.genre ?? '-',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text('${song.year ?? ""}', style: theme.textTheme.bodySmall),
            ),
            const Icon(Icons.favorite_border_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '0:00';
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(width: 8),
          Icon(icon, size: 16),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant);
  }
}
