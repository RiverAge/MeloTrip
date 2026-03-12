import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/album_page_controls.dart';
part 'parts/album_grid_view.dart';
part 'parts/album_table_view.dart';
part 'parts/album_detail_list_view.dart';

const kAlbumPageSize = 50;
const AlbumListQuery kDesktopAlbumsQuery = AlbumListQuery(
  type: 'alphabeticalByName',
  size: kAlbumPageSize,
);

enum AlbumViewType { grid, table, detail }

class DesktopAlbumsPage extends ConsumerStatefulWidget {
  const DesktopAlbumsPage({super.key});

  @override
  ConsumerState<DesktopAlbumsPage> createState() => _DesktopAlbumsPageState();
}

class _DesktopAlbumsPageState extends ConsumerState<DesktopAlbumsPage> {
  AlbumViewType _viewType = AlbumViewType.grid;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref
          .read(paginatedAlbumListProvider(kDesktopAlbumsQuery).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final PaginatedListSnapshot<AlbumEntity> albumState = ref.watch(
      paginatedAlbumListProvider(kDesktopAlbumsQuery),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PageHeader(
            title: l10n.album,
            count: albumState.items.length,
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          _Toolbar(l10n: l10n),
          Expanded(
            child: albumState.items.isEmpty && albumState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(albumState, theme, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    PaginatedListSnapshot<AlbumEntity> albumState,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    switch (_viewType) {
      case AlbumViewType.grid:
        return AlbumGridView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
        );
      case AlbumViewType.table:
        return AlbumTableView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
          l10n: l10n,
        );
      case AlbumViewType.detail:
        return AlbumDetailListView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
        );
    }
  }
}
