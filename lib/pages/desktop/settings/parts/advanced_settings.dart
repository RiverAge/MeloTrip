import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/cache_file_path.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class AdvancedSettings extends ConsumerWidget {
  const AdvancedSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final cachedSizeAsync = ref.watch(cachedFileSizeProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: <Widget>[
        Align(
          alignment: .topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                SettingSectionHeader(
                  title: l10n.settingsTabAdvanced,
                  icon: Icons.code_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingRow(
                        label: l10n.cachedSize,
                        description: cachedSizeAsync.when(
                          data: (size) => _formatBytes(size.toInt()),
                          loading: () => l10n.calculating,
                          error: (_, _) => 'Error',
                        ),
                        onTap: () async {
                          final path = await getCacheFilePath();
                          final dir = Directory(path);
                          if (dir.existsSync()) {
                            await dir.delete(recursive: true);
                            await dir.create(recursive: true);
                          }
                          ref.invalidate(cachedFileSizeProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.clearCacheSuccess),
                                behavior: SnackBarBehavior.floating,
                                width: 320,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        trailing: Icon(
                          Icons.delete_sweep_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SettingRow(
                        label: l10n.searchHistory,
                        description: l10n.resetToDefaults,
                        onTap: () {
                          ref.read(userConfigProvider.notifier).setConfiguration(
                                recentSearches:
                                    const ValueUpdater<String?>(null),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.deleted),
                              behavior: SnackBarBehavior.floating,
                              width: 320,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        trailing: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0B';
    const List<String> units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)}${units[unitIndex]}';
  }
}
