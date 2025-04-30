import 'package:flutter/material.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/albums_builder.dart';
part 'parts/favorite_play_all.dart';
part 'parts/songs_builder.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  @override
  State<StatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  _FavoritePageState();

  late final TabController _controller = TabController(length: 2, vsync: this);
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = _controller.index;
    _controller.animation?.addListener(_indexChangeListener);

    super.initState();
  }

  @override
  void dispose() {
    _controller.animation?.removeListener(_indexChangeListener);
    _controller.dispose();

    super.dispose();
  }

  _indexChangeListener() {
    if (_currentIndex != _controller.index) {
      setState(() {
        _currentIndex = _controller.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AsyncValueBuilder(
        provider: favoriteProvider,
        builder: (_, data, ref) {
          final songs = data.subsonicResponse?.starred?.song;
          final albums = data.subsonicResponse?.starred?.album;
          final canPlayAll =
              songs != null && songs.isNotEmpty && _currentIndex == 1;
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.myFavorites),
              elevation: 3,
              actions: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      canPlayAll
                          ? _FavoritePlayAll(songs: songs)
                          : const SizedBox.shrink(),
                ),
              ],
              bottom: TabBar(
                controller: _controller,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.album),
                  Tab(text: AppLocalizations.of(context)!.song),
                ],
              ),
            ),
            body: TabBarView(
              controller: _controller,
              children: [
                _AlbumsBuilder(
                  albums: albums,
                  onToggleFavorite: (album) {
                    ref.read(favoriteProvider.notifier).toggleAlbum(album);
                  },
                ),
                _SongsBuilder(
                  songs: songs,
                  onToggleFavorite: (song) {
                    ref.read(favoriteProvider.notifier).toggleSong(song);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
