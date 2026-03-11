import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/widget/artwork_image.dart';

part 'parts/artist_page_sections.dart';

class DesktopArtistsPage extends ConsumerStatefulWidget {
  const DesktopArtistsPage({super.key});

  @override
  ConsumerState<DesktopArtistsPage> createState() => _DesktopArtistsPageState();
}

class _DesktopArtistsPageState extends ConsumerState<DesktopArtistsPage> {
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
    final visibleArtists = state.items.take(state.offset).toList(
      growable: false,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArtistPageHeader(title: l10n.artist, count: state.items.length),
          ArtistPageToolbar(l10n: l10n),
          Expanded(
            child: state.items.isEmpty && state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ArtistGrid(
                    artists: visibleArtists,
                    hasMore: state.hasMore,
                    scrollController: _scrollController,
                  ),
          ),
        ],
      ),
    );
  }
}
