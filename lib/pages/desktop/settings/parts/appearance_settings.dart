import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class AppearanceSettings extends ConsumerWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final userConfig = ref.watch(userConfigProvider).value;

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
                  title: l10n.theme,
                  icon: Icons.palette_outlined,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingSingleChoiceRow<ThemeMode>(
                        label: l10n.theme,
                        value: userConfig?.theme ?? ThemeMode.system,
                        options: <SettingSingleChoiceOption<ThemeMode>>[
                          SettingSingleChoiceOption<ThemeMode>(
                            value: ThemeMode.system,
                            label: l10n.systemDefault,
                          ),
                          SettingSingleChoiceOption<ThemeMode>(
                            value: ThemeMode.light,
                            label: l10n.themeLight,
                          ),
                          SettingSingleChoiceOption<ThemeMode>(
                            value: ThemeMode.dark,
                            label: l10n.themeDark,
                          ),
                        ],
                        onChanged: (ThemeMode value) {
                          ref.read(userConfigProvider.notifier).setConfiguration(
                                theme: ValueUpdater<ThemeMode?>(value),
                              );
                        },
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
}
