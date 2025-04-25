import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/pages/favorite/favorite_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/playlist/playlist_page.dart';
import 'package:melo_trip/pages/settings/app_theme_page.dart';
import 'package:melo_trip/pages/settings/music_quality_page.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/cache_file.dart';
part 'parts/server_status.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
        children: [
          _ServerStatus(),
          Card(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => AppThemePage()));
                  },
                  leading: Icon(Icons.contrast),
                  title: Text('主题'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: const Text('音质'),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const MusicQualityPage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.featured_play_list_outlined),
                  title: const Text('我的歌单'),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const PlaylistPage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: const Text('我的收藏'),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const FavoritePage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            label: const Text('退出登录'),
          ),
          // ElevatedButton(onPressed: onPressed, child: child)
          // Card(
          //   child: ListTile(
          //     leading: const Icon(Icons.logout),
          //     title: const Text('退出登录'),
          //     onTap: _onLogout,
          //     trailing: const Icon(Icons.arrow_forward),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _onLogout() async {
    final navigator = Navigator.of(context);
    final playerHandler = await AppPlayerHandler.instance;
    final player = playerHandler.player;
    await player.pause();
    final user = await User.instance;
    user.clear();
    navigator.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => const InitialPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }
}
