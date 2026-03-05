part of '../tab_page.dart';

class _SidebarServerCard extends ConsumerWidget {
  const _SidebarServerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final scanStatus = ref.watch(scanStatusProvider);
    final isOnline = scanStatus.asData?.value?.subsonicResponse?.status == 'ok';
    final statusText = isOnline ? l10n.serverOnline : l10n.serverOffline;
    return AsyncValueBuilder(
      provider: currentUserProvider,
      loading: (_, _) => const SizedBox.shrink(),
      empty: (_, _) => const SizedBox.shrink(),
      builder: (context, user, _) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.surface,
                child: ClipOval(
                  child: Image.asset(
                    'images/navidrome.png',
                    width: 30,
                    height: 30,
                    fit: .cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      user.host?.replaceFirst(RegExp(r'^https?://'), '') ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: const TextStyle(fontWeight: .w700, fontSize: 13),
                    ),
                    Text(
                      '${user.username ?? '-'} · $statusText',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
