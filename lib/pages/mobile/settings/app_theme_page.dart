import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';
import 'package:melo_trip/pages/shared/settings/theme_seed_options.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
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
        provider: sessionConfigProvider,
        builder: (context, config, ref) {
          final AppLocalizations l10n = AppLocalizations.of(context)!;
          final ThemeData theme = Theme.of(context);
          final AppThemeSeed activeSeed = config.themeSeed ?? AppThemeSeed.rose;
          final List<ThemeSeedOption> themeSeeds = buildThemeSeedOptions(l10n);
          return ListView(
            children: [
              ListTile(
                onTap: () => _onTap(ref, .system),
                leading: Icon(
                  config.theme == .system
                      ? Icons.auto_mode
                      : Icons.auto_mode_outlined,
                ),
                title: Text(l10n.systemDefault),
                trailing: config.theme == .system
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              ListTile(
                onTap: () => _onTap(ref, .light),
                leading: Icon(
                  config.theme == .light
                      ? Icons.light_mode
                      : Icons.light_mode_outlined,
                ),
                title: Text(l10n.themeLight),
                trailing: config.theme == .light
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              ListTile(
                onTap: () => _onTap(ref, .dark),
                leading: Icon(
                  config.theme == .dark
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined,
                ),
                title: Text(l10n.themeDark),
                trailing: config.theme == .dark
                    ? const Icon(Icons.check)
                    : null,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(l10n.themeColor, style: theme.textTheme.titleSmall),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: themeSeeds.map((ThemeSeedOption option) {
                    final bool selected = option.seed == activeSeed;
                    final Color swatchColor = option.seed.color;
                    return InkWell(
                      onTap: () => _onThemeSeedTap(ref, option.seed),
                      borderRadius: BorderRadius.circular(6),
                      child: Tooltip(
                        message: option.label,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selected
                                ? swatchColor
                                : swatchColor.withValues(alpha: 0.82),
                            border: Border.all(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant.withValues(
                                      alpha: 0.45,
                                    ),
                              width: selected ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: theme.colorScheme.onPrimary,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onTap(WidgetRef ref, ThemeMode mode) {
    ref
        .read(userSessionProvider.notifier)
        .setConfiguration(theme: ValueUpdater(mode));
  }

  void _onThemeSeedTap(WidgetRef ref, AppThemeSeed seed) {
    ref
        .read(userSessionProvider.notifier)
        .setConfiguration(themeSeed: ValueUpdater(seed));
  }
}
