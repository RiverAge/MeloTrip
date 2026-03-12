part of '../favorites_page.dart';

class _TrackList extends StatelessWidget {
  const _TrackList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
    final ThemeData theme = Theme.of(context);
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
        children: <Widget>[
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
    final ThemeData theme = Theme.of(context);
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
        children: <Widget>[
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
