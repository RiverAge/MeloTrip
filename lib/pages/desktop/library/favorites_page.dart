import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/pages/desktop/library/artists_page.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/pages/desktop/library/songs_page.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0),
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          _PageHeader(
            title: l10n.myFavorites,
            currentType: _currentType,
            onTypeChanged: (type) => setState(() => _currentType = type),
          ),
          const _Toolbar(),
          Expanded(
            child: AsyncValueBuilder(
              provider: favoriteProvider,
              builder: (context, result, ref) {
                final starred = result.data?.subsonicResponse?.starred;
                return _buildContent(starred);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StarredEntity? starred) {
    switch (_currentType) {
      case 'albums':
        final albums = starred?.album ?? const <AlbumEntity>[];
        return _AlbumGrid(albums: albums);
      case 'artists':
        final artists = starred?.artist ?? const <ArtistEntity>[];
        return _ArtistGrid(artists: artists);
      case 'songs':
      default:
        final songs = starred?.song ?? const <SongEntity>[];
        return _TrackList(songs: songs);
    }
  }
}
