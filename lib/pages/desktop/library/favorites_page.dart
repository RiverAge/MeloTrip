import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopFavoritesPage extends ConsumerStatefulWidget {
  const DesktopFavoritesPage({super.key});

  @override
  ConsumerState<DesktopFavoritesPage> createState() =>
      _DesktopFavoritesPageState();
}

class _DesktopFavoritesPageState extends ConsumerState<DesktopFavoritesPage> {
  String _currentType = 'songs';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeader(
            title: l10n.myFavorites,
            currentType: _currentType,
            onTypeChanged: (type) => setState(() => _currentType = type),
          ),
          const _Toolbar(),
          Expanded(
            child: AsyncValueBuilder(
              provider: favoriteProvider,
              builder: (context, data, ref) {
                final starred = data.subsonicResponse?.starred;
                switch (_currentType) {
                  case 'albums':
                    return _AlbumGrid(
                      albums: starred?.album ?? const <AlbumEntity>[],
                    );
                  case 'artists':
                    return _ArtistGrid(
                      artists: starred?.artist ?? const <ArtistEntity>[],
                    );
                  case 'songs':
                  default:
                    return _TrackList(
                      songs: starred?.song ?? const <SongEntity>[],
                    );
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
    required this.currentType,
    required this.onTypeChanged,
  });

  final String title;
  final String currentType;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
            child: Icon(
              Icons.play_arrow_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: onTypeChanged,
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'songs', child: Text(l10n.song)),
                      PopupMenuItem(value: 'albums', child: Text(l10n.album)),
                      PopupMenuItem(value: 'artists', child: Text(l10n.artist)),
                    ],
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                currentType == 'songs'
                    ? l10n.song
                    : currentType == 'albums'
                    ? l10n.album
                    : l10n.artist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _ToolbarButton(label: l10n.name, icon: Icons.sort_by_alpha_rounded),
          const SizedBox(width: 16),
          const _ToolbarIcon(icon: Icons.refresh_rounded),
          const Spacer(),
          const _ToolbarIcon(icon: Icons.grid_view_rounded),
        ],
      ),
    );
  }
}

class _TrackList extends StatelessWidget {
  const _TrackList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: songs.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) => ListTile(
        leading: Text('${index + 1}'),
        title: Text(songs[index].title ?? '-'),
        subtitle: Text(songs[index].artist ?? '-'),
        trailing: Icon(
          Icons.favorite_rounded,
          color: theme.colorScheme.primary,
          size: 16,
        ),
      ),
    );
  }
}

class _AlbumGrid extends StatelessWidget {
  const _AlbumGrid({required this.albums});

  final List<AlbumEntity> albums;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) => Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: .4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            albums[index].name ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ArtistGrid extends StatelessWidget {
  const _ArtistGrid({required this.artists});

  final List<ArtistEntity> artists;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) => Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person_rounded,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artists[index].name ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
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
        mainAxisSize: MainAxisSize.min,
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
