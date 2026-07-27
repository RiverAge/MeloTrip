part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

/// Inline search field shown below the play queue header when expanded.
class _PlayQueueSearchField extends StatelessWidget {
  const _PlayQueueSearchField({
    required this.controller,
    required this.variant,
  });

  final TextEditingController controller;
  final PlayQueuePanelVariant variant;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        _isDesktop ? 18 : 16,
        4,
        _isDesktop ? 18 : 12,
        8,
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: .search,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          isDense: true,
          hintText: AppLocalizations.of(context)!.searchPlayQueue,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, _, _) {
              if (controller.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 18,
                icon: const Icon(Icons.close_rounded),
                onPressed: controller.clear,
              );
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: colorScheme.surface.withValues(alpha: _isDesktop ? 0.88 : 0.92),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.22),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.22),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when an active search query yields no matches.
class _PlayQueueNoMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          AppLocalizations.of(context)!.noSearchResults,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
