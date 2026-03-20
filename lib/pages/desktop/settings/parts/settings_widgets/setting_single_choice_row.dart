part of '../settings_widgets.dart';

class SettingSingleChoiceOption<T> {
  const SettingSingleChoiceOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

class SettingSingleChoiceRow<T> extends StatelessWidget {
  const SettingSingleChoiceRow({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<SettingSingleChoiceOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: .center,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kSettingLabelMaxWidth),
            child: Text(
              label,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RadioGroup<T>(
              groupValue: value,
              onChanged: (T? next) {
                if (next == null) return;
                onChanged(next);
              },
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6,
                runSpacing: 6,
                children: options.map((SettingSingleChoiceOption<T> option) {
                  final bool selected = option.value == value;
                  final Color borderColor = selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.72,
                        );
                  final Color backgroundColor = selected
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.7,
                        )
                      : theme.colorScheme.surfaceContainerLow.withValues(
                          alpha: 0.9,
                        );
                  final Color textColor = selected
                      ? theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.82,
                        )
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.82,
                        );
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (option.icon != null) ...[
                          Icon(option.icon, size: 14, color: textColor),
                          const SizedBox(width: 6),
                        ],
                        Text(option.label),
                      ],
                    ),
                    selected: selected,
                    onSelected: (_) => onChanged(option.value),
                    showCheckmark: false,
                    selectedColor: backgroundColor,
                    backgroundColor: backgroundColor,
                    side: BorderSide(color: borderColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: textColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
