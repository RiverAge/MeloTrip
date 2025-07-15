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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.searchHistory),
                // Icon(Icons.delete)
                Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () {
                        ref
                            .read(userConfigProvider.notifier)
                            .setConfiguration(
                              recentSearches: ValueUpdater(null),
                            );
                      },
                      icon: const Icon(Icons.delete),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: AsyncValueBuilder(
                provider: userConfigProvider,
                empty: (context, ref) => const SizedBox.shrink(),
                builder: (context, config, ref) {
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 5.0,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.center,
                    children:
                        (config.recentSearches ?? '')
                            .split(',')
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  onTap(e);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
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
