part of '../search_page.dart';

class _SearchHistory extends StatelessWidget {
  const _SearchHistory({required this.onTap});

  final void Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.searchHistory),
                // Icon(Icons.delete)
                Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () {
                        ref
                            .read(userSessionProvider.notifier)
                            .setConfiguration(
                              recentSearches: const ValueUpdater<String>(''),
                            );
                      },
                      icon: const Icon(Icons.delete),
                    );
                  },
                ),
              ],
            ),
            Align(
              alignment: .centerLeft,
              child: AsyncValueBuilder(
                provider: sessionConfigProvider,
                empty: (context, ref) => const SizedBox.shrink(),
                builder: (context, config, ref) {
                  final effectiveSearches = config.recentSearches;
                  if (effectiveSearches == null) return const SizedBox.shrink();

                  final searchItems = effectiveSearches
                      .split(',')
                      .map((it) => it.trim())
                      .where((it) => it.isNotEmpty)
                      .toList();
                  if (searchItems.isEmpty) return const SizedBox.shrink();

                  return Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    alignment: .start,
                    runAlignment: .center,
                    children: searchItems
                        .map(
                          (item) => InkWell(
                            onTap: () => onTap(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .1),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
