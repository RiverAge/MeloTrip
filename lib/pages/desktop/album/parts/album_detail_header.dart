part of '../album_detail_page.dart';

class _AlbumDetailHeader extends StatelessWidget {
  const _AlbumDetailHeader({
    required this.album,
    required this.songs,
    required this.showTitle,
    required this.onPlayAlbum,
    required this.onAddToQueue,
    required this.formatTotalDuration,
  });

  final AlbumEntity album;
  final List<SongEntity> songs;
  final bool showTitle;
  final Future<void> Function(WidgetRef ref) onPlayAlbum;
  final Future<void> Function(WidgetRef ref) onAddToQueue;
  final String Function(List<SongEntity> songs) formatTotalDuration;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color headerTextColor = isDark
        ? colorScheme.onSurface
        : colorScheme.onPrimary;
    final Color headerSubTextColor = headerTextColor.withValues(alpha: 0.84);

    return SliverAppBar(
      pinned: true,
      expandedHeight: 380,
      backgroundColor: colorScheme.surface,
      elevation: showTitle ? 2 : 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: AnimatedOpacity(
        opacity: showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          album.name ?? '',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: .bold,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ArtworkImage(id: album.id, fit: .cover, size: 800),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                color: colorScheme.scrim.withValues(
                  alpha: isDark ? 0.32 : 0.44,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  colors: <Color>[
                    colorScheme.scrim.withValues(alpha: isDark ? 0.1 : 0.18),
                    colorScheme.scrim.withValues(alpha: isDark ? 0.18 : 0.32),
                    colorScheme.scrim.withValues(alpha: isDark ? 0.28 : 0.46),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Row(
                crossAxisAlignment: .end,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ArtworkImage(id: album.id, size: 600),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .end,
                      mainAxisSize: .min,
                      children: <Widget>[
                        Text(
                          l10n.album,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: headerSubTextColor,
                            fontWeight: .bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 110),
                          child: Text(
                            album.name ?? '-',
                            maxLines: 2,
                            overflow: .ellipsis,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: headerTextColor,
                              fontWeight: .w900,
                              letterSpacing: -1.0,
                              fontSize: 34,
                              height: 1.08,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _AlbumMetaRow(
                          album: album,
                          songs: songs,
                          contentColor: headerSubTextColor,
                          formatTotalDuration: formatTotalDuration,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          album.artist ?? '-',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: headerTextColor,
                            fontWeight: .w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Consumer(
                              builder: (context, ref, _) {
                                return FilledButton.icon(
                                  onPressed: songs.isEmpty
                                      ? null
                                      : () => onPlayAlbum(ref),
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 24,
                                  ),
                                  label: Text(l10n.play),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            AsyncValueBuilder(
                              provider: appPlayerHandlerProvider,
                              loading: (_, _) => _HeaderOutlineButton(
                                icon: Icons.shuffle_rounded,
                                label: l10n.shuffleOn,
                                textColor: headerTextColor,
                                borderColor: headerTextColor.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                              builder: (context, player, _) {
                                return AsyncStreamBuilder(
                                  provider: player.shuffleStream,
                                  builder: (context, shuffleEnabled) {
                                    return _HeaderOutlineButton(
                                      icon: shuffleEnabled
                                          ? Icons.shuffle_on_rounded
                                          : Icons.shuffle_rounded,
                                      label: shuffleEnabled
                                          ? l10n.shuffleOn
                                          : l10n.shuffleOff,
                                      textColor: headerTextColor,
                                      borderColor: headerTextColor.withValues(
                                        alpha: 0.35,
                                      ),
                                      onPressed: () =>
                                          player.setShuffleModeEnabled(
                                            !shuffleEnabled,
                                          ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Consumer(
                              builder: (context, ref, _) {
                                return _HeaderOutlineButton(
                                  icon: Icons.playlist_play_rounded,
                                  label: l10n.addToPlayQueue,
                                  textColor: headerTextColor,
                                  borderColor: headerTextColor.withValues(
                                    alpha: 0.35,
                                  ),
                                  onPressed: songs.isEmpty
                                      ? null
                                      : () async {
                                          await onAddToQueue(ref);
                                          if (!context.mounted) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.addToPlayQueue,
                                              ),
                                            ),
                                          );
                                        },
                                );
                              },
                            ),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, _) {
                                return Rating(
                                  rating: album.userRating ?? 0,
                                  color: headerSubTextColor,
                                  onRating: (value) {
                                    ref
                                        .read(
                                          albumDetailProvider(
                                            album.id,
                                          ).notifier,
                                        )
                                        .setRatingResult(value);
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            Consumer(
                              builder: (context, ref, _) {
                                final bool isFavorite = album.starred != null;
                                return IconButton(
                                  tooltip: isFavorite
                                      ? l10n.unfavorite
                                      : l10n.favorite,
                                  onPressed: () async {
                                    await ref
                                        .read(
                                          albumDetailProvider(
                                            album.id,
                                          ).notifier,
                                        )
                                        .toggleFavoriteResult();
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 20,
                                    color: isFavorite
                                        ? colorScheme.error
                                        : headerSubTextColor,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumMetaRow extends StatelessWidget {
  const _AlbumMetaRow({
    required this.album,
    required this.songs,
    required this.contentColor,
    required this.formatTotalDuration,
  });

  final AlbumEntity album;
  final List<SongEntity> songs;
  final Color contentColor;
  final String Function(List<SongEntity> songs) formatTotalDuration;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String year = album.year == null
        ? ''
        : '${l10n.songMetaYear}: ${album.year}';
    final String count = '${songs.length} ${l10n.songCountUnit}';
    final String duration = formatTotalDuration(songs);
    final String summary = <String>[
      year,
      count,
      duration,
    ].where((String item) => item.isNotEmpty).join(' · ');

    return Row(
      children: <Widget>[
        Icon(Icons.music_note_rounded, size: 14, color: contentColor),
        const SizedBox(width: 4),
        Text(
          summary,
          style: theme.textTheme.bodyMedium?.copyWith(color: contentColor),
        ),
      ],
    );
  }
}
