part of '../general_settings.dart';

extension _GeneralSettingsLanguageDialog on _GeneralSettingsState {
  String _getLanguageName(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return l10n.systemDefault;
    if (locale.languageCode == 'zh') return l10n.simpleChinese;
    if (locale.languageCode == 'en') return l10n.english;
    return locale.toString();
  }

  void _showLanguageDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              mainAxisSize: .min,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.language,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
                const SizedBox(height: 10),
                _LanguageOption(
                  label: l10n.systemDefault,
                  selected: ref.watch(sessionConfigProvider).value?.locale == null,
                  onTap: () {
                    ref.read(userSessionProvider.notifier).setConfiguration(
                      locale: const ValueUpdater<Locale?>(null),
                    );
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  label: l10n.simpleChinese,
                  selected:
                      ref.watch(sessionConfigProvider).value?.locale?.languageCode ==
                      'zh',
                  onTap: () {
                    ref.read(userSessionProvider.notifier).setConfiguration(
                      locale: const ValueUpdater<Locale?>(Locale('zh', 'CN')),
                    );
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  label: l10n.english,
                  selected:
                      ref.watch(sessionConfigProvider).value?.locale?.languageCode ==
                      'en',
                  onTap: () {
                    ref.read(userSessionProvider.notifier).setConfiguration(
                      locale: const ValueUpdater<Locale?>(Locale('en', 'US')),
                    );
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: .centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.42)
                : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.35)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: <Widget>[
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: selected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
