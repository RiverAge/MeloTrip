import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/folder/folders.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/folders_page_shell.dart';
part 'parts/folders_page_tree.dart';
part 'parts/folders_page_table.dart';

class DesktopFoldersPage extends ConsumerWidget {
  const DesktopFoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeader(l10n: l10n),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 220, maxWidth: 320),
                    child: _LeftPane(),
                  ),
                ),
                const VerticalDivider(width: 1),
                const Expanded(flex: 7, child: _RightPane()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
