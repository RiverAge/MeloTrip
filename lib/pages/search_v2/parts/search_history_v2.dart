part of '../search_page_v2.dart';

class _SearchHistory extends ConsumerWidget {
  const _SearchHistory({required this.onTap});

  final void Function(String) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder<String?>(
      provider: userConfigProvider.select(
        (v) => v.whenData((config) => config?.recentSearches),
      ),
      loading: (context, ref) => const SizedBox.shrink(),
      builder: (context, recentStr, ref) {
        final searches =
            recentStr?.split(',').where((s) => s.isNotEmpty).toList() ?? [];
        if (searches.isEmpty) {
          return const Center(child: NoData());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.searchHistory,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(userConfigProvider.notifier)
                        .setConfiguration(
                          recentSearches: const ValueUpdater(''),
                        );
                  },
                  icon: const Icon(Icons.delete_outline, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: searches.map((s) {
                return ActionChip(
                  label: Text(s),
                  onPressed: () => onTap(s),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
