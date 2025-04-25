part of '../settings_page.dart';

class _ServerStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(right: 8),
                    child: Image.asset('images/navidrome.png'),
                  ),
                  Text('Navidrome', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            Divider(),
            AsyncValueBuilder(
              provider: scanStatusProvider,
              builder: (context, data, ref) {
                final scanStatus = data.subsonicResponse?.scanStatus;
                final lastScan = scanStatus?.lastScan;
                return GridView.count(
                  primary: false,
                  // padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  childAspectRatio: 3.0, // 宽
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.cloud),
                      title: Text('状态'),
                      subtitle: Text(
                        data.subsonicResponse?.status == 'ok' ? '在线' : '离线',
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.commit),
                      title: Text('版本'),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
