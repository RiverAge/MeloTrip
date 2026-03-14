import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/pages/desktop/library/albums_page.dart';
import 'package:melo_trip/pages/desktop/library/widgets/view_types.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_page_controls.dart';
import 'package:melo_trip/pages/desktop/library/widgets/album_views.dart';
import 'package:melo_trip/provider/album/albums.dart';

class DesktopGenreDetailPage extends ConsumerStatefulWidget {
  const DesktopGenreDetailPage({super.key, required this.genre});

  final GenreEntity genre;

  @override
  ConsumerState<DesktopGenreDetailPage> createState() =>
      _DesktopGenreDetailPageState();
}

class _DesktopGenreDetailPageState
    extends ConsumerState<DesktopGenreDetailPage> {
  AppViewType _viewType = AppViewType.grid;
  final ScrollController _scrollController = ScrollController();

  late final AlbumListQuery _query;

  @override
  void initState() {
    super.initState();
    _query = AlbumListQuery(
      type: 'byGenre',
      genre: widget.genre.value,
      size: kAlbumPageSize,
    );
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
      ref.read(paginatedAlbumListProvider(_query).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final PaginatedListSnapshot<AlbumEntity> albumState = ref.watch(
      paginatedAlbumListProvider(_query),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CustomGenreHeader(
            genre: widget.genre,
            viewType: _viewType,
            onViewTypeChanged: (AppViewType type) =>
                setState(() => _viewType = type),
            count: widget.genre.albumCount ?? albumState.items.length,
          ),
          Expanded(
            child: albumState.items.isEmpty && albumState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(albumState, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    PaginatedListSnapshot<AlbumEntity> albumState,
    AppLocalizations l10n,
  ) {
    switch (_viewType) {
      case AppViewType.grid:
        return AlbumGridView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
        );
      case AppViewType.table:
        return AlbumTableView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
          l10n: l10n,
        );
      case AppViewType.detail:
        return AlbumGridView(
          albums: albumState.items,
          hasMore: albumState.hasMore,
          scrollController: _scrollController,
        );
    }
  }
}

class _CustomGenreHeader extends StatelessWidget {
  const _CustomGenreHeader({
    required this.genre,
    required this.viewType,
    required this.onViewTypeChanged,
    required this.count,
  });

  final GenreEntity genre;
  final AppViewType viewType;
  final ValueChanged<AppViewType> onViewTypeChanged;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final int? songCount = genre.songCount;
    final String summary = songCount == null
        ? '$count ${l10n.album}'
        : '$count ${l10n.album} · $songCount ${l10n.songCountUnit}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.style_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      genre.value ?? '',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AlbumViewSwitcher(
                current: viewType,
                onChanged: onViewTypeChanged,
                showDetailOption: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
