import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: AsyncValueBuilder(
        provider: appLocaleProvider,
        nullableBuilder: (context, locale, ref) {
          return ListView(
            children: [
              ListTile(
                onTap: () {
                  ref.read(appLocaleProvider.notifier).setLocale(null);
                },
                title: Text(AppLocalizations.of(context)!.systemDefault),
                trailing: locale == null ? const Icon(Icons.check) : null,
              ),
              Divider(),
              ListTile(
                onTap: () {
                  ref
                      .read(appLocaleProvider.notifier)
                      .setLocale(Locale('en', 'US'));
                },
                title: Text(AppLocalizations.of(context)!.english),
                subtitle: Text(AppLocalizations.of(context)!.us),
                trailing:
                    locale == Locale('en', 'US')
                        ? const Icon(Icons.check)
                        : null,
              ),
              Divider(),
              ListTile(
                onTap: () {
                  ref
                      .read(appLocaleProvider.notifier)
                      .setLocale(Locale('zh', 'CN'));
                },
                title: Text(AppLocalizations.of(context)!.simpleChinese),
                subtitle: Text(AppLocalizations.of(context)!.cn),
                trailing:
                    locale == Locale('zh', 'CN')
                        ? const Icon(Icons.check)
                        : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
