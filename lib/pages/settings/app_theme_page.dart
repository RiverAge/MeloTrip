import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/app_theme_mode/app_theme_mode.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class AppThemePage extends StatelessWidget {
  const AppThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主题设置'), elevation: 3.0),
      body: AsyncValueBuilder(
        provider: appThemeModeProvider,
        builder: (context, data, ref) {
          return ListView(
            children: [
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.dark),
                leading: Icon(
                  data == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined,
                ),
                title: Text('深色'),
                trailing:
                    data == ThemeMode.dark ? const Icon(Icons.check) : null,
              ),
              Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.light),
                leading: Icon(
                  data == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.light_mode_outlined,
                ),
                title: Text('浅色'),
                trailing:
                    data == ThemeMode.light ? const Icon(Icons.check) : null,
              ),
              Divider(),
              ListTile(
                onTap: () => _onTap(ref, ThemeMode.system),
                leading: Icon(
                  data == ThemeMode.system
                      ? Icons.auto_mode
                      : Icons.auto_mode_outlined,
                ),
                title: Text('跟随系统'),
                trailing:
                    data == ThemeMode.system ? const Icon(Icons.check) : null,
              ),
            ],
          );
        },
      ),
    );
  }

  _onTap(WidgetRef ref, ThemeMode mode) {
    ref.read(appThemeModeProvider.notifier).setMode(mode);
  }
}
