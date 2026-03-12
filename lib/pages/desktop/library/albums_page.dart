import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_views.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_page_controls.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_detail_list_view_widget.dart';
import 'package:melo_trip/provider/album/albums.dart';

enum AlbumViewType { grid, table, detail }

const kAlbumPageSize = 50;
const AlbumListQuery kDesktopAlbumsQuery = AlbumListQuery(
  type: 'alphabeticalByName',
  size: kAlbumPageSize,
);

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
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AlbumPageHeader(
            title: l10n.album,
            count: albumState.items.length,
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          AlbumToolbar(l10n: l10n),
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
