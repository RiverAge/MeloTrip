part of '../settings_page.dart';

class _ServerStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: .start,
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
                  Text(l10n.serverStatus, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            Divider(),
            AsyncValueBuilder(
              provider: scanStatusProvider,
              builder: (context, result, ref) {
                final data = result.data;
                final scanStatus = data?.subsonicResponse?.scanStatus;
                final lastScan = scanStatus?.lastScan;
                final isOnline = result.isOk;
                return GridView.count(
                  primary: false,
                  // padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  childAspectRatio: 3.0,
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.cloud),
                      title: Text(l10n.serverStatus),
                      subtitle: Text(
                        isOnline ? l10n.serverOnline : l10n.serverOffline,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.commit),
                      title: Text(l10n.version),
                      subtitle: Text(data?.subsonicResponse?.version ?? ''),
                    ),
                    ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text(l10n.serverSongCount),
                      subtitle: Text('${scanStatus?.count}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.scanner),
                      title: Text(l10n.serverScaning),
                      subtitle: Text(
                        scanStatus?.scanning == true ? l10n.yes : l10n.no,
                      ),
                    ),
                    if (lastScan != null)
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: Text(l10n.serverLastScanTime),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(lastScan),
                        ),
                      ),
                    ListTile(
                      leading: const Icon(Icons.art_track),
                      title: Text(l10n.cachedSize),
                      subtitle: const Row(children: [_CacheFile()]),
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
