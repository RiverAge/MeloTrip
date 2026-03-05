import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';

enum _AlbumViewType { grid, table, detail }

class DesktopAlbumsPage extends ConsumerStatefulWidget {
  const DesktopAlbumsPage({super.key});

  @override
  ConsumerState<DesktopAlbumsPage> createState() => _DesktopAlbumsPageState();
}

class _DesktopAlbumsPageState extends ConsumerState<DesktopAlbumsPage> {
  _AlbumViewType _viewType = _AlbumViewType.grid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(
            title: l10n.album,
            count: 2565,
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          _Toolbar(),
          Expanded(
            child: AsyncValueBuilder(
              provider: albumsProvider(AlumsType.random),
              builder: (context, data, ref) {
                final albums = data.subsonicResponse?.albumList?.album ?? [];
                if (_viewType == _AlbumViewType.grid) {
                  return _AlbumGrid(albums: albums);
                } else if (_viewType == _AlbumViewType.table) {
                  return _AlbumTable(albums: albums);
                } else {
                  return _AlbumDetailList(albums: albums);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
  });
  final String title;
  final int count;
  final _AlbumViewType viewType;
  final ValueChanged<_AlbumViewType> onViewTypeChanged;

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
          _ViewSwitcher(current: viewType, onChanged: onViewTypeChanged),
        ],
      ),
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.current, required this.onChanged});
  final _AlbumViewType current;
  final ValueChanged<_AlbumViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ViewItem(
            icon: Icons.grid_view_rounded,
            selected: current == _AlbumViewType.grid,
            onTap: () => onChanged(_AlbumViewType.grid),
          ),
          _ViewItem(
            icon: Icons.view_list_rounded,
            selected: current == _AlbumViewType.table,
            onTap: () => onChanged(_AlbumViewType.table),
          ),
          _ViewItem(
            icon: Icons.view_headline_rounded,
            selected: current == _AlbumViewType.detail,
            onTap: () => onChanged(_AlbumViewType.detail),
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  const _ViewItem({required this.icon, required this.selected, required this.onTap});
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
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
        ],
      ),
    );
  }
}

class _AlbumGrid extends StatelessWidget {
  const _AlbumGrid({required this.albums});
  final List<AlbumEntity> albums;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return DesktopAlbumCard(album: albums[index]);
      },
    );
  }
}

class _AlbumTable extends StatelessWidget {
  const _AlbumTable({required this.albums});
  final List<AlbumEntity> albums;

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
              const SizedBox(width: 80, child: Icon(Icons.access_time_rounded, size: 14, color: Colors.grey)),
              const Expanded(flex: 3, child: Text('GENRE', style: _headerStyle)),
              const SizedBox(width: 80, child: Text('YEAR', style: _headerStyle)),
              const SizedBox(width: 30),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return _AlbumTableRow(index: index + 1, album: album);
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

class _AlbumTableRow extends StatelessWidget {
  const _AlbumTableRow({required this.index, required this.album});
  final int index;
  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
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
                    child: ArtworkImage(id: album.id, size: 80, width: 40, height: 40),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          album.name ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                        ),
                        Text(
                          album.artist ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Text('35:54', style: theme.textTheme.bodySmall), // Mock or sum tracks
            ),
            Expanded(
              flex: 3,
              child: Text(
                album.genre ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 80,
              child: Text('${album.year ?? ""}', style: theme.textTheme.bodySmall),
            ),
            const Icon(Icons.favorite_border_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _AlbumDetailList extends StatelessWidget {
  const _AlbumDetailList({required this.albums});
  final List<AlbumEntity> albums;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return _AlbumDetailItem(album: albums[index]);
      },
    );
  }
}

class _AlbumDetailItem extends ConsumerWidget {
  const _AlbumDetailItem({required this.album});
  final AlbumEntity album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 240,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ArtworkImage(id: album.id, size: 500, width: 240, height: 240),
                ),
                const SizedBox(height: 16),
                Text(
                  album.name ?? '-',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                Text(
                  album.artist ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${album.year ?? ""} • ${album.songCount ?? 0} Songs',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: AsyncValueBuilder(
              provider: albumDetailProvider(album.id ?? ''),
              builder: (context, data, ref) {
                final songs = data.subsonicResponse?.album?.song ?? [];
                return Column(
                  children: songs.asMap().entries.map((entry) => _AlbumDetailTrackRow(index: entry.key + 1, song: entry.value)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumDetailTrackRow extends StatelessWidget {
  const _AlbumDetailTrackRow({required this.index, required this.song});
  final int index;
  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
            SizedBox(
              width: 40,
              child: Text(index.toString().padLeft(2, '0'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
            ),
          Expanded(
            child: Text(song.title ?? '-', style: theme.textTheme.bodyMedium),
          ),
          Text(_formatDuration(song.duration), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(width: 16),
          const Icon(Icons.favorite_border_rounded, size: 14, color: Colors.grey),
        ],
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
