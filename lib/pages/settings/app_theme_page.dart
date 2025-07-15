import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
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
          return ListView(
            children: [
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.system),
                leading: Icon(
                  config.theme == ThemeMode.system
                      ? Icons.auto_mode
                      : Icons.auto_mode_outlined,
                ),
                title: Text(AppLocalizations.of(context)!.systemDefault),
                trailing:
                    config.theme == ThemeMode.system
                        ? const Icon(Icons.check)
                        : null,
              ),
              Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.light),
                leading: Icon(
                  config.theme == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.light_mode_outlined,
                ),
                title: Text(AppLocalizations.of(context)!.themeLight),
                trailing:
                    config.theme == ThemeMode.light
                        ? const Icon(Icons.check)
                        : null,
              ),
              Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.dark),
                leading: Icon(
                  config.theme == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined,
                ),
                title: Text(AppLocalizations.of(context)!.themeDark),
                trailing:
                    config.theme == ThemeMode.dark
                        ? const Icon(Icons.check)
                        : null,
              ),
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
}
