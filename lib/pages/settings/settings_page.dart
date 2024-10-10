import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melo_trip/pages/favorite/favorite_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/playlist/playlist_page.dart';
import 'package:melo_trip/pages/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_theme_mode/app_theme_mode.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/theme_mode.dart';
part 'parts/image_cache.dart';
part 'parts/stream_cache.dart';

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
        itemCount: 7,
        itemBuilder: (_, index) {
          if (index == 0) {
            return const ListTile(
                leading: Icon(Icons.contrast),
                title: Text('主题'),
                trailing: _ThemeMode());
          }
          if (index == 1) {
            return const ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('图片缓存'),
                trailing: _ImageCache());
          }
          if (index == 2) {
            return const ListTile(
                leading: Icon(Icons.art_track),
                title: Text('音乐缓存'),
                trailing: _StreamCache());
          }
          if (index == 3) {
            return ListTile(
                leading: const Icon(Icons.high_quality),
                title: const Text('音质'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: ((_) => const MusicQualityPage()))),
                trailing: const Icon(Icons.arrow_forward));
          }
          if (index == 4) {
            return ListTile(
                leading: const Icon(Icons.featured_play_list_outlined),
                title: const Text('我的歌单'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const PlaylistPage()))),
                trailing: const Icon(Icons.arrow_forward));
          }
          if (index == 5) {
            return ListTile(
                leading: const Icon(Icons.favorite_border_outlined),
                title: const Text('我的收藏'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const FavoritePage()))),
                trailing: const Icon(Icons.arrow_forward));
          }
          return ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('退出登录'),
              onTap: _onLogout,
              trailing: const Icon(Icons.arrow_forward));
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
            reverseTransitionDuration: Duration.zero),
        (route) => false);
  }
}
