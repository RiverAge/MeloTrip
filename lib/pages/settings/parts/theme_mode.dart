part of '../settings_page.dart';

class _ThemeMode extends StatelessWidget {
  const _ThemeMode();
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
        provider: appThemeModeProvider,
        builder: (context, data, ref) {
          return SegmentedButton(
            segments: [
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: const Text('深色'),
                  icon: Icon(data == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.dark_mode_outlined)),
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: const Text('浅色'),
                  icon: Icon(data == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.light_mode_outlined)),
              ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: const Text('系统'),
                  icon: Icon(data == ThemeMode.system
                      ? Icons.auto_mode
                      : Icons.auto_mode_outlined))
            ],
            onSelectionChanged: (val) {
              ref.read(appThemeModeProvider.notifier).setMode(val.first);
            },
            selected: <ThemeMode>{data},
          );
        });
  }
}
