import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/desktop/window_title_bar_client.dart';
import 'package:window_title_bar/window_title_bar.dart';

class DesktopWindowTitleBar extends ConsumerWidget {
  const DesktopWindowTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final windowTitleBar = ref.watch(windowTitleBarClientProvider);

    return StreamBuilder<WindowTitleBarStateSnapshot>(
      stream: windowTitleBar.stateStream,
      initialData: windowTitleBar.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? windowTitleBar.state;
        final isMaximized = state.windowState == WindowBarState.maximized;
        return DecoratedBox(
          decoration: BoxDecoration(
            color:
                state.backgroundColor ??
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, topPadding + 6, 8, 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: windowTitleBar.toggleMaximize,
                    child: Text(
                      state.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.windowMinimize,
                  onPressed: windowTitleBar.minimize,
                  icon: const Icon(Icons.remove_rounded),
                ),
                IconButton(
                  tooltip: isMaximized
                      ? l10n.windowRestore
                      : l10n.windowMaximize,
                  onPressed: windowTitleBar.toggleMaximize,
                  icon: Icon(
                    isMaximized
                        ? Icons.filter_none_rounded
                        : Icons.crop_square_rounded,
                  ),
                ),
                IconButton(
                  tooltip: l10n.windowClose,
                  onPressed: windowTitleBar.close,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
