part of '../artists_page.dart';

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
        return ArtistCard(
          key: ValueKey<String>(artists[index].id),
          artist: artists[index],
        );
      },
    );
  }
}

class ArtistCard extends StatefulWidget {
  const ArtistCard({required this.artist, super.key});

  final ArtistIndexEntry artist;

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = widget.artist;
    final baseBorderColor = theme.colorScheme.outlineVariant.withValues(
      alpha: 0.28,
    );
    final hoverBorderColor = theme.colorScheme.primary.withValues(alpha: 0.34);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered ? hoverBorderColor : baseBorderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(
                  alpha: _isHovered ? 0.16 : 0.08,
                ),
                blurRadius: _isHovered ? 22 : 12,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: Material(
            color: theme.colorScheme.surfaceContainerLow.withValues(
              alpha: _isHovered ? 0.96 : 0.82,
            ),
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DesktopArtistDetailPage(artistId: artist.id),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            artist.coverArt != null
                                ? ArtworkImage(
                                    id: artist.coverArt!,
                                    size: 300,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: .cover,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.45),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 48,
                                        color: theme.colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.28),
                                      ),
                                    ),
                                  ),
                            AnimatedOpacity(
                              opacity: _isHovered ? 1 : 0,
                              duration: const Duration(milliseconds: 180),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      artist.name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: _isHovered ? FontWeight.w800 : FontWeight.bold,
                      ),
                    ),
                    if (artist.albumCount != null)
                      Text(
                        '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: _isHovered ? 0.82 : 0.6,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
