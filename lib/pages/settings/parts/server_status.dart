part of '../settings_page.dart';

class _ServerStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: AsyncValueBuilder(
        provider: scanStatusProvider,
        builder: (context, data, ref) {
          final scanStatus = data.subsonicResponse?.scanStatus;
          final lastScan = scanStatus?.lastScan;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    '状态',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                GridView.count(
                  primary: false,
                  // padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  childAspectRatio: 3.0, // 宽
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.cloud),
                      title: Text('服务器状态'),
                      subtitle: Text(
                        data.subsonicResponse?.status == 'ok' ? '在线' : '离线',
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.commit),
                      title: Text('服务器版本'),
                      subtitle: Text(data.subsonicResponse?.version ?? ''),
                    ),
                    ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text('歌曲数量'),
                      subtitle: Text('${scanStatus?.count}首'),
                    ),
                    ListTile(
                      leading: Icon(Icons.scanner),
                      title: Text('正在扫描'),
                      subtitle: Text(scanStatus?.scanning == true ? '是' : '否'),
                    ),
                    if (lastScan != null)
                      ListTile(
                        leading: Icon(Icons.update),
                        title: Text('上次扫描'),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(lastScan),
                        ),
                      ),
                    const ListTile(
                      leading: Icon(Icons.art_track),
                      title: Text('已缓存'),
                      subtitle: Row(children: [_CacheFile()]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
