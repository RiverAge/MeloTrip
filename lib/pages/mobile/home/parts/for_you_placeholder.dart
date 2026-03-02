part of '../home_page.dart';

class _ForYouPlaceholder extends StatelessWidget {
  const _ForYouPlaceholder();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.guessYouLike,
            style: const TextStyle(fontSize: 17, fontWeight: .bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
                begin: .topLeft,
                end: .bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.recommendedToday,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: .w900,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your daily mix of music is ready. Tap to explore personalized suggestions.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    shape: .circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
