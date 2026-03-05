import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class GeneralSettings extends ConsumerWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _SectionHeader(title: l10n.theme),
        _SettingRow(
          label: '跟随系统',
          description: '使用系统定义的浅色或深色主题',
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
        _SettingRow(
          label: '主题',
          description: '设置应用的主题',
          trailing: _DropdownButton(label: 'Default Dark'),
        ),
        _SettingRow(
          label: '强调色',
          description: '设置应用的强调色',
          trailing: Row(
            mainAxisSize: .min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF3574FC),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('rgb(53, 116, 252)', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const Divider(height: 40),
        _SectionHeader(title: '应用'),
        _SettingRow(
          label: l10n.language,
          description: '设置应用的语言 (需要重启应用)',
          trailing: _DropdownButton(label: '简体中文 (zh-Hans)'),
        ),
        _SettingRow(
          label: '字体',
          description: '设置应用使用的字体',
          trailing: _DropdownButton(label: 'Poppins'),
        ),
        _SettingRow(
          label: '首页精选轮播',
          description: '控制是否在主页上显示大型特色轮播',
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: .w900,
          fontSize: 22,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.description,
    required this.trailing,
  });
  final String label;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: .bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _DropdownButton extends StatelessWidget {
  const _DropdownButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(width: 20),
          Icon(
            Icons.unfold_more_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
