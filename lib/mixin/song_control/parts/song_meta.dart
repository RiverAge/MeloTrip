part of '../song_control.dart';

class _SongMeta extends StatelessWidget {
  const _SongMeta({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArtistDetailPage(artistId: song.artistId),
                  ),
                );
              },
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.person_2),
              title: Text('歌手：${song.artist}'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlbumDetailPage(albumId: song.albumId),
                  ),
                );
              },
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.album_outlined),
              title: Text('专辑：${song.album}'),
            ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.access_time),
              title: Text('时长：${durationFormatter(song.duration)}'),
            ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.disc_full_outlined),
              title: Text('格式：${song.suffix}'),
            ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.high_quality_outlined),
              title: Text('比特率：${song.bitRate}K'),
            ),
            if (song.genre != null) const Divider(),
            if (song.genre != null)
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: const Icon(Icons.gesture_rounded),
                title: Text('风格：${song.genre}'),
              ),
            if (song.year != null) const Divider(),
            if (song.year != null)
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: const Icon(Icons.date_range_outlined),
                title: Text('年份：${song.year}'),
              ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.route_outlined),
              title: Text('路径：${song.path}'),
            ),
            if (song.samplingRate != null && song.samplingRate != 0)
              const Divider(),
            if (song.samplingRate != null && song.samplingRate != 0)
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: const Icon(Icons.equalizer_outlined),
                title: Text('采样频率：${song.samplingRate}'),
              ),
            if (song.track != null) const Divider(),
            if (song.track != null)
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: const Icon(Icons.disc_full_outlined),
                title: Text('音轨号：${song.track}'),
              ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.pin_outlined),
              title: Text('盘号：${song.bpm}'),
            ),
            const Divider(),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              leading: const Icon(Icons.storage_rounded),
              title: Text('文件大小：${fileSizeFormatter(song.size)}'),
            ),
          ],
        ),
      ),
    );
  }
}
