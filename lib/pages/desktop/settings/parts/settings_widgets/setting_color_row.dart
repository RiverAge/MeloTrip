part of '../settings_widgets.dart';

class SettingColorRow extends StatelessWidget {
  const SettingColorRow({
    super.key,
    required this.label,
    required this.value,
    required this.palette,
    required this.onChanged,
    this.tooltipForColor,
  });

  final String label;
  final int value;
  final List<int> palette;
  final ValueChanged<int> onChanged;
  final String Function(int color)? tooltipForColor;

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
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: palette.map((int color) {
                final bool active = color == value;
                final Color swatchColor = Color(color);
                return Tooltip(
                  message: tooltipForColor?.call(color) ?? '',
                  child: IconButton(
                    onPressed: () => onChanged(color),
                    icon: active
                        ? Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : const SizedBox.shrink(),
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: active
                          ? swatchColor
                          : swatchColor.withValues(alpha: 0.82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: active
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(
                                  alpha: 0.45,
                                ),
                          width: active ? 2.0 : 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
