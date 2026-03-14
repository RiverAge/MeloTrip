part of '../artists_page.dart';

class ArtistPageHeader extends StatelessWidget {
  const ArtistPageHeader({
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
    super.key,
  });

  final String title;
  final int count;
  final AppViewType viewType;
  final ValueChanged<AppViewType> onViewTypeChanged;

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
              fontWeight: .w900,
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
          ArtistViewSwitcher(
            current: viewType,
            onChanged: onViewTypeChanged,
          ),
        ],
      ),
    );
  }
}

class ArtistViewSwitcher extends StatelessWidget {
  const ArtistViewSwitcher({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final AppViewType current;
  final ValueChanged<AppViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ArtistViewItem(
            icon: Icons.grid_view_rounded,
            selected: current == AppViewType.grid,
            onTap: () => onChanged(AppViewType.grid),
          ),
          _ArtistViewItem(
            icon: Icons.view_list_rounded,
            selected: current == AppViewType.table,
            onTap: () => onChanged(AppViewType.table),
          ),
        ],
      ),
    );
  }
}

class _ArtistViewItem extends StatelessWidget {
  const _ArtistViewItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class ArtistPageToolbar extends StatelessWidget {
  const ArtistPageToolbar({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
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
              const SizedBox(width: 56),
              Expanded(flex: 5, child: Text(l10n.name, style: headerStyle)),
              SizedBox(
                width: 120,
                child: Text(l10n.albumCount, style: headerStyle),
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
              return ArtistTableRow(artist: artists[index]);
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
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
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
              SizedBox(
                width: 120,
                child: Text(
                  '${artist.albumCount ?? 0}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.78,
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
                        '${artist.albumCount}',
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
