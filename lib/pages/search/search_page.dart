import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/pages/artist/artist_detail_page.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/search/search_history.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/no_data.dart';

part 'parts/search_bar.dart';
part 'parts/album_item.dart';
part 'parts/song_item.dart';
part 'parts/artist_item.dart';
part 'parts/tag.dart';
part 'parts/search_history.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  bool _isFoucs = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _Searchbar(
            controller: _controller,
            onFocusChange:
                (hasFocus) => setState(() {
                  _isFoucs = hasFocus;
                }),
            onSubmitted:
                (value) => setState(() {
                  _query = value;
                }),
          ),
        ),
        body:
            _isFoucs
                ? _SearchHistory(
                  onTap: (value) {
                    _controller.text = value;
                  },
                )
                : _query == ''
                ? const SizedBox.shrink()
                : SafeArea(
                  child: AsyncValueBuilder(
                    provider: searchProvider(_query),
                    builder: (context, value, _) {
                      final songs =
                          value.subsonicResponse?.searchResult3?.song ?? [];
                      final albums =
                          value.subsonicResponse?.searchResult3?.album ?? [];
                      final artists =
                          value.subsonicResponse?.searchResult3?.artist ?? [];
                      if (songs.isEmpty && albums.isEmpty && artists.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: NoData(),
                        );
                      }
                      return Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: '歌曲'),
                              Tab(text: '专辑'),
                              Tab(text: '艺术家'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.separated(
                                  itemBuilder:
                                      (_, index) =>
                                          _SongItem(song: songs[index]),
                                  separatorBuilder:
                                      (_, index) => const Divider(
                                        indent: 0,
                                        endIndent: 0,
                                        height: 0,
                                      ),
                                  itemCount: songs.length,
                                ),
                                ListView.separated(
                                  itemBuilder:
                                      (_, index) =>
                                          _AlbumItem(album: albums[index]),
                                  separatorBuilder:
                                      (_, index) => const Divider(
                                        indent: 0,
                                        endIndent: 0,
                                        height: 0,
                                      ),
                                  itemCount: albums.length,
                                ),
                                ListView.separated(
                                  itemBuilder:
                                      (_, index) =>
                                          _ArtistItem(artist: artists[index]),
                                  separatorBuilder:
                                      (_, index) => const Divider(
                                        indent: 0,
                                        endIndent: 0,
                                        height: 0,
                                      ),
                                  itemCount: artists.length,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
