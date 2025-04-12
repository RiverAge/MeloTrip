import 'package:flutter/material.dart';
import 'package:melo_trip/pages/favorite/favorite_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/playlist/playlist_page.dart';
import 'package:melo_trip/pages/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_theme_mode/app_theme_mode.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/theme_mode.dart';
part 'parts/cache_file.dart';

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
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: 6,
        itemBuilder: (_, index) {
          if (index == 0) {
            return const ListTile(
              leading: Icon(Icons.contrast),
              title: Text('主题'),
              trailing: _ThemeMode(),
            );
          }

          if (index == 1) {
            return const ListTile(
              leading: Icon(Icons.art_track),
              title: Text('缓存'),
              trailing: _CacheFile(),
            );
          }
          if (index == 2) {
            return ListTile(
              leading: const Icon(Icons.high_quality),
              title: const Text('音质'),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((_) => const MusicQualityPage()),
                    ),
                  ),
              trailing: const Icon(Icons.arrow_forward),
            );
          }
          if (index == 3) {
            return ListTile(
              leading: const Icon(Icons.featured_play_list_outlined),
              title: const Text('我的歌单'),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const PlaylistPage())),
                  ),
              trailing: const Icon(Icons.arrow_forward),
            );
          }
          if (index == 4) {
            return ListTile(
              leading: const Icon(Icons.favorite_border_outlined),
              title: const Text('我的收藏'),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const FavoritePage())),
                  ),
              trailing: const Icon(Icons.arrow_forward),
            );
          }
          return ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('退出登录'),
            onTap: _onLogout,
            trailing: const Icon(Icons.arrow_forward),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _onLogout() async {
    final navigator = Navigator.of(context);
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
