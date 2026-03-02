import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopSearchPage extends ConsumerWidget {
  const DesktopSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.searchHistory),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: .6,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: query.trim().isEmpty
                  ? const Center(child: NoData())
                  : AsyncValueBuilder(
                      provider: searchResultProvider,
                      loading: (_, _) =>
                          const Center(child: CircularProgressIndicator()),
                      empty: (_, _) => const NoData(),
                      builder: (context, data, _) {
                        final albums =
                            data.subsonicResponse?.searchResult3?.album ?? [];
                        if (albums.isEmpty) return const NoData();
                        return ListView.separated(
                          itemCount: albums.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final album = albums[index];
                            return Material(
                              color: theme.colorScheme.surfaceContainerHigh
                                  .withValues(alpha: .55),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DesktopAlbumDetailPage(
                                        albumId: album.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: ArtworkImage(
                                          id: album.id,
                                          width: 54,
                                          height: 54,
                                          fit: .cover,
                                          size: 200,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              album.name ?? '-',
                                              maxLines: 1,
                                              overflow: .ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              album.artist ?? '-',
                                              maxLines: 1,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
