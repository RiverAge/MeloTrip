part of '../artists_page.dart';

class ArtistTableView extends StatelessWidget {
  const ArtistTableView({
    required this.artists,
    required this.hasMore,
    required this.scrollController,
    required this.l10n,
    super.key,
  });

  final List<ArtistIndexEntry> artists;
  final bool hasMore;
  final ScrollController scrollController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.7,
    );
    final headerStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ).copyWith(color: headerColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 56),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ),
              Expanded(flex: 5, child: Text(l10n.name, style: headerStyle)),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      l10n.albumCount,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: headerStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: artists.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= artists.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return ArtistTableRow(
                key: ValueKey<String>(artists[index].id),
                artist: artists[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ArtistTableRow extends StatefulWidget {
  const ArtistTableRow({required this.artist, super.key});

  final ArtistIndexEntry artist;

  @override
  State<ArtistTableRow> createState() => _ArtistTableRowState();
}

class _ArtistTableRowState extends State<ArtistTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = widget.artist;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DesktopArtistDetailPage(artistId: artist.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: artist.coverArt == null
                    ? Container(
                        width: 40,
                        height: 40,
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      )
                    : ArtworkImage(
                        id: artist.coverArt!,
                        size: 120,
                        width: 40,
                        height: 40,
                        fit: .cover,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Text(
                  artist.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      '',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.78,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
