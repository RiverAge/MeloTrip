import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/library/widgets/view_types.dart';
import 'package:melo_trip/pages/desktop/artist/artist_detail_page.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/widget/artwork_image.dart';

part 'parts/artist_page_sections.dart';

class DesktopArtistsPage extends ConsumerStatefulWidget {
  const DesktopArtistsPage({super.key});

  @override
  ConsumerState<DesktopArtistsPage> createState() => _DesktopArtistsPageState();
}

class _DesktopArtistsPageState extends ConsumerState<DesktopArtistsPage> {
  AppViewType _viewType = AppViewType.grid;
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
      ref.read(paginatedArtistsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(paginatedArtistsProvider);
    final visibleArtists = state.items
        .take(state.offset)
        .toList(growable: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withValues(
        alpha: 0,
      ),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          ArtistPageHeader(
            title: l10n.artist,
            count: state.items.length,
            viewType: _viewType,
            onViewTypeChanged: (type) => setState(() => _viewType = type),
          ),
          ArtistPageToolbar(l10n: l10n),
          Expanded(
            child: state.items.isEmpty && state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(visibleArtists, state.hasMore, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<ArtistIndexEntry> artists,
    bool hasMore,
    AppLocalizations l10n,
  ) {
    switch (_viewType) {
      case AppViewType.grid:
        return ArtistGrid(
          artists: artists,
          hasMore: hasMore,
          scrollController: _scrollController,
        );
      case AppViewType.table:
        return ArtistTableView(
          artists: artists,
          hasMore: hasMore,
          scrollController: _scrollController,
          l10n: l10n,
        );
      default:
        return ArtistGrid(
          artists: artists,
          hasMore: hasMore,
          scrollController: _scrollController,
        );
    }
  }
}
