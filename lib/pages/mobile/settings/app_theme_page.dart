import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';
import 'package:melo_trip/pages/shared/settings/theme_seed_options.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class AppThemePage extends StatelessWidget {
  const AppThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.theme),
        elevation: 3.0,
      ),
      body: AsyncValueBuilder(
        provider: userConfigProvider,
        builder: (context, config, ref) {
          final AppLocalizations l10n = AppLocalizations.of(context)!;
          final AppThemeSeed activeSeed = config.themeSeed ?? AppThemeSeed.rose;
          final List<ThemeSeedOption> themeSeeds = buildThemeSeedOptions(l10n);
          return ListView(
            children: [
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.system),
                leading: Icon(
                  config.theme == ThemeMode.system
                      ? Icons.auto_mode
                      : Icons.auto_mode_outlined,
                ),
                title: Text(l10n.systemDefault),
                trailing: config.theme == ThemeMode.system
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.light),
                leading: Icon(
                  config.theme == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.light_mode_outlined,
                ),
                title: Text(l10n.themeLight),
                trailing: config.theme == ThemeMode.light
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.dark),
                leading: Icon(
                  config.theme == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined,
                ),
                title: Text(l10n.themeDark),
                trailing: config.theme == ThemeMode.dark
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  l10n.themeColor,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ...themeSeeds.map((option) {
                final bool selected = option.seed == activeSeed;
                return ListTile(
                  onTap: () => _onThemeSeedTap(ref, option.seed),
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      color: option.seed.color,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(width: 20, height: 20),
                  ),
                  title: Text(option.label),
                  trailing: selected ? const Icon(Icons.check) : null,
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _onTap(WidgetRef ref, ThemeMode mode) {
    ref
        .read(userConfigProvider.notifier)
        .setConfiguration(theme: ValueUpdater(mode));
  }

  void _onThemeSeedTap(WidgetRef ref, AppThemeSeed seed) {
    ref
        .read(userConfigProvider.notifier)
        .setConfiguration(themeSeed: ValueUpdater(seed));
  }
}
