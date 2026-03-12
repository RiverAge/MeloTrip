part of '../artists_page.dart';

class ArtistPageHeader extends StatelessWidget {
  const ArtistPageHeader({required this.title, required this.count, super.key});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}

class ArtistPageToolbar extends StatelessWidget {
  const ArtistPageToolbar({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color iconColor = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            l10n.name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.sort_by_alpha_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Icon(Icons.refresh_rounded, size: 18, color: iconColor),
          const Spacer(),
          Icon(Icons.grid_view_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Icon(Icons.tune_rounded, size: 18, color: iconColor),
        ],
      ),
    );
  }
}

class ArtistGrid extends StatelessWidget {
  const ArtistGrid({
    required this.artists,
    required this.hasMore,
    required this.scrollController,
    super.key,
  });

  final List<ArtistIndexEntry> artists;
  final bool hasMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: artists.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= artists.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ArtistCard(artist: artists[index]);
      },
    );
  }
}

class ArtistCard extends StatelessWidget {
  const ArtistCard({required this.artist, super.key});

  final ArtistIndexEntry artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: artist.coverArt != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ArtworkImage(
                    id: artist.coverArt!,
                    size: 300,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: .3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: .2,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Text(
          artist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (artist.albumCount != null)
          Text(
            '${artist.albumCount}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
            ),
          ),
      ],
    );
  }
}
