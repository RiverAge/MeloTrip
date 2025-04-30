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
                  childAspectRatio: 3.0,
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.cloud),
                      title: Text(AppLocalizations.of(context)!.serverStatus),
                      subtitle: Text(
                        data.subsonicResponse?.status == 'ok'
                            ? AppLocalizations.of(context)!.serverOnline
                            : AppLocalizations.of(context)!.serverOffline,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.commit),
                      title: Text(AppLocalizations.of(context)!.version),
                      subtitle: Text(data.subsonicResponse?.version ?? ''),
                    ),
                    ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text(
                        AppLocalizations.of(context)!.serverSongCount,
                      ),
                      subtitle: Text('${scanStatus?.count}'),
                    ),
                    ListTile(
                      leading: Icon(Icons.scanner),
                      title: Text(AppLocalizations.of(context)!.serverScaning),
                      subtitle: Text(
                        scanStatus?.scanning == true
                            ? AppLocalizations.of(context)!.yes
                            : AppLocalizations.of(context)!.no,
                      ),
                    ),
                    if (lastScan != null)
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: Text(
                          AppLocalizations.of(context)!.serverLastScanTime,
                        ),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(lastScan),
                        ),
                      ),
                    ListTile(
                      leading: const Icon(Icons.art_track),
                      title: Text(AppLocalizations.of(context)!.cachedSize),
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
