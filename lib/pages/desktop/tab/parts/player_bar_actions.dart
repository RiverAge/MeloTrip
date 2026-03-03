part of '../tab_page.dart';

class _DesktopPlayerBarActions extends StatelessWidget {
  const _DesktopPlayerBarActions({
    required this.current,
    required this.colorScheme,
  });

  final SongEntity? current;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconMutedColor = colorScheme.onSurfaceVariant.withValues(alpha: .72);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 220;
        return Consumer(
          builder: (context, ref, _) {
            final detail = ref.watch(songDetailProvider(current?.id));
            final effectiveSong =
                detail.asData?.value?.subsonicResponse?.song ?? current;
            final rating = effectiveSong?.userRating ?? 0;
            final isStarred = effectiveSong?.starred != null;
            return Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .end,
              children: [
                if (!compact) ...[
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      Tooltip(
                        message: '$rating/5',
                        child: Rating(
                          rating: rating,
                          onRating: (value) {
                            ref
                                .read(songRatingProvider.notifier)
                                .updateRating(current?.id, value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    IconButton(
                      onPressed: current == null
                          ? null
                          : () => ref
                                .read(songFavoriteProvider.notifier)
                                .toggleFavorite(current),
                      iconSize: 20,
                      visualDensity: .compact,
                      constraints: const BoxConstraints.tightFor(
                        width: 34,
                        height: 34,
                      ),
                      padding: .zero,
                      tooltip: isStarred ? l10n.unfavorite : l10n.favorite,
                      icon: Icon(
                        isStarred
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isStarred ? colorScheme.primary : iconMutedColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DesktopVolumeBar(compact: compact),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
