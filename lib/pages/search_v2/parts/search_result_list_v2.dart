part of '../search_page_v2.dart';

class _SearchResultListV2 extends StatelessWidget {
  const _SearchResultListV2({
    required this.query,
    required this.songs,
    required this.albums,
    required this.artists,
  });

  final String query;
  final List<SongEntity> songs;
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;

  @override
  Widget build(BuildContext context) {
    // 基础过滤：艺人必须有专辑才会显示在艺人列表中
    final filteredArtists = artists
        .where((a) => (a.albumCount ?? 0) > 0)
        .toList();

    // 针对歌曲进行“智能过滤”：解决搜索专辑名时带出全专辑歌曲的问题
    // 逻辑：优先显示标题包含关键词的歌曲；如果没有，则显示 API 返回的前 3 首（兜底）
    final lowerQuery = query.toLowerCase().trim();
    final titleMatchedSongs = songs.where((s) {
      final title = s.title?.toLowerCase() ?? '';
      return title.contains(lowerQuery);
    }).toList();

    final displaySongs = titleMatchedSongs.isNotEmpty
        ? titleMatchedSongs
        : songs.take(5).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // 1. 艺人部分
        if (filteredArtists.isNotEmpty) ...[
          _buildSectionHeader(context, AppLocalizations.of(context)!.artist),
          ...filteredArtists.map((artist) => _ArtistCardV2(artist: artist)),
          const SizedBox(height: 12),
        ],

        // 2. 专辑部分
        if (albums.isNotEmpty) ...[
          _buildSectionHeader(context, AppLocalizations.of(context)!.album),
          ...albums.map((album) => _AlbumCardV2(album: album)),
          const SizedBox(height: 12),
        ],

        // 3. 歌曲部分
        if (displaySongs.isNotEmpty) ...[
          _buildSectionHeader(context, AppLocalizations.of(context)!.song),
          ...displaySongs.map((song) => _SongTileV2(song: song)),
        ],

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
