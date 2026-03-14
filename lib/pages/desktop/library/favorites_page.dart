import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/pages/desktop/artist/artist_detail_page.dart';
import 'package:melo_trip/pages/desktop/library/widgets/view_types.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_page_controls.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_views.dart';
import 'package:melo_trip/pages/desktop/library/artists_page.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/pages/desktop/library/songs_page.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/favorites_header.dart';
part 'parts/favorites_views.dart';

class DesktopFavoritesPage extends ConsumerStatefulWidget {
  const DesktopFavoritesPage({super.key});

  @override
  ConsumerState<DesktopFavoritesPage> createState() =>
      _DesktopFavoritesPageState();
}

class _DesktopFavoritesPageState extends ConsumerState<DesktopFavoritesPage> {
  String _currentType = 'songs';
  AppViewType _viewType = AppViewType.grid;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          _PageHeader(
            title: l10n.myFavorites,
            currentType: _currentType,
            onTypeChanged: (type) => setState(() => _currentType = type),
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          const _Toolbar(),
          Expanded(
            child: AsyncValueBuilder(
              provider: favoriteProvider,
              builder: (context, data, ref) {
                final starred = data.subsonicResponse?.starred;
                return _buildContent(starred, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StarredEntity? starred, AppLocalizations l10n) {
    switch (_currentType) {
      case 'albums':
        final albums = starred?.album ?? const <AlbumEntity>[];
        return _viewType == AppViewType.grid
            ? _AlbumGrid(albums: albums)
            : _AlbumTableView(albums: albums, l10n: l10n);
      case 'artists':
        final artists = starred?.artist ?? const <ArtistEntity>[];
        return _viewType == AppViewType.grid
            ? _ArtistGrid(artists: artists)
            : _ArtistTableView(artists: artists, l10n: l10n);
      case 'songs':
      default:
        final songs = starred?.song ?? const <SongEntity>[];
        return _TrackList(songs: songs);
    }
  }
}
