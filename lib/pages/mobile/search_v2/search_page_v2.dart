import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/mobile/album/album_detail_page.dart';
import 'package:melo_trip/pages/mobile/artist/artist_detail_page.dart';
import 'package:melo_trip/pages/mobile/song_control/song_control.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';

part 'parts/search_header_v2.dart';
part 'parts/search_history_v2.dart';
part 'parts/search_result_list_v2.dart';
part 'parts/artist_card_v2.dart';
part 'parts/album_card_v2.dart';
part 'parts/song_tile_v2.dart';

class SearchPageV2 extends ConsumerStatefulWidget {
  const SearchPageV2({super.key});

  @override
  ConsumerState<SearchPageV2> createState() => _SearchPageV2State();
}

class _SearchPageV2State extends ConsumerState<SearchPageV2> {
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory(String value) async {
    await ref.read(userConfigProvider.notifier).setConfiguration(
      recentSearch: ValueUpdater<String>(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SearchHeaderV2(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (val) =>
                ref.read(searchQueryProvider.notifier).state = val,
            onReFocused: () {
              if (_controller.text.isEmpty) {
                ref.read(searchQueryProvider.notifier).state = '';
              }
            },
            onSubmitted: (val) {
              _saveToHistory(val);
              _focusNode.unfocus();
            },
          ),
        ),
      ),
      body: activeQuery.isEmpty
          ? _SearchHistory(
              onTap: (val) {
                _controller.text = val;
                ref.read(searchQueryProvider.notifier).state = val;
                _saveToHistory(val);
                _focusNode.unfocus();
              },
            )
          : AsyncValueBuilder<SubsonicResponse?>(
              provider: searchResultProvider,
              loading: (context, ref) => const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: CircularProgressIndicator(),
                ),
              ),
              builder: (context, response, ref) {
                final SearchResult3Entity? searchResult =
                    response?.subsonicResponse?.searchResult3;
                final List<SongEntity> songs = searchResult?.song ?? [];
                final List<AlbumEntity> albums = searchResult?.album ?? [];
                final List<ArtistEntity> artists = searchResult?.artist ?? [];

                if (songs.isEmpty && albums.isEmpty && artists.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: NoData(),
                  );
                }

                return _SearchResultListV2(
                  query: activeQuery,
                  songs: songs,
                  albums: albums,
                  artists: artists,
                );
              },
            ),
    );
  }
}
