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
                const Text("搜索历史"),
                // Icon(Icons.delete)
                Consumer(builder: (context, ref, child) {
                  return IconButton(
                      onPressed: () {
                        ref.read(searchHistoryProvider.notifier).clearAll();
                      },
                      icon: const Icon(Icons.delete));
                })
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: AsyncValueBuilder(
                    provider: searchHistoryProvider,
                    empty: (context, ref) => const SizedBox.shrink(),
                    builder: (context, data, ref) {
                      return Wrap(
                          spacing: 10.0,
                          runSpacing: 5.0,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.center,
                          children: data
                              .map((e) => InkWell(
                                  onTap: () {
                                    onTap(e);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.1),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                      ))))
                              .toList());
                    }))
          ],
        ),
      ),
    );
  }
}
