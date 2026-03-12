part of '../home_page.dart';

class _DesktopGenreSection extends ConsumerWidget {
  const _DesktopGenreSection();

  List<Color> _buildGenrePalette(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final baseHue = HSLColor.fromColor(theme.colorScheme.primary).hue;
    final saturation = isDark ? .92 : .9;
    final lightnessA = isDark ? .62 : .42;
    final lightnessB = isDark ? .68 : .5;
    const hueStep = 360.0 / 15.0;
    const order = [0, 8, 3, 11, 6, 14, 1, 9, 4, 12, 7, 2, 10, 5, 13];

    return List.generate(15, (index) {
      final slot = order[index];
      final hue = (baseHue + slot * hueStep) % 360;
      final lightness = index.isEven ? lightnessA : lightnessB;
      return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.songMetaGenre),
        AsyncValueBuilder(
          provider: albumListProvider(
            AlbumListQuery(type: AlbumListType.recent.name),
          ),
          builder: (context, data, _) {
            final albums = data;
            final fallback = albums
                .map((it) => it.genre?.trim())
                .whereType<String>()
                .where((it) => it.isNotEmpty)
                .toSet()
                .take(15)
                .toList();

            if (fallback.isEmpty) return const SizedBox.shrink();

            final seedPalette = _buildGenrePalette(theme);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fallback.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.4,
              ),
              itemBuilder: (_, index) {
                return _GenreTile(
                  genre: fallback[index],
                  color: seedPalette[index % seedPalette.length],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _GenreTile extends StatefulWidget {
  const _GenreTile({required this.genre, required this.color});

  final String genre;
  final Color color;

  @override
  State<_GenreTile> createState() => _GenreTileState();
}

class _GenreTileState extends State<_GenreTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: DesktopMotionTokens.medium,
        curve: DesktopMotionTokens.standardCurve,
        decoration: BoxDecoration(
          color: _isHovering
              ? colorScheme.surfaceContainerHighest.withValues(alpha: .82)
              : colorScheme.surfaceContainerHigh.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isHovering
                ? colorScheme.outline.withValues(alpha: .32)
                : colorScheme.outlineVariant.withValues(alpha: .2),
          ),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: .14),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stripWidth = constraints.maxWidth * .1;
            return Row(
              children: [
                Container(
                  width: stripWidth,
                  color: widget.color.withValues(alpha: .9),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      widget.genre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
