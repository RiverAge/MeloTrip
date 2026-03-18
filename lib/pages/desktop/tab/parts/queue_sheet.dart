part of '../tab_page.dart';

class _DesktopQueueSheet extends ConsumerWidget {
  const _DesktopQueueSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 420,
            minHeight: 360,
            maxWidth: 760,
            maxHeight: 560,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.28),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: PlayQueuePanel(
              variant: PlayQueuePanelVariant.desktop,
              onClose: () => Navigator.of(context).pop(),
              closeOnSelection: true,
            ),
          ),
        ),
      ),
    );
  }
}
