import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/provider/genre/genres.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopGenresPage extends ConsumerWidget {
  const DesktopGenresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withValues(
        alpha: 0,
      ),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(title: l10n.songMetaGenre),
          _Toolbar(l10n: l10n),
          Expanded(
            child: AsyncValueBuilder(
              provider: genresProvider,
              builder: (context, data, _) {
                return _GenreTable(genres: data, l10n: l10n);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flag_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: .w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _ToolbarButton(label: l10n.name, icon: Icons.sort_by_alpha_rounded),
          const SizedBox(width: 16),
          const _ToolbarIcon(icon: Icons.refresh_rounded),
          const Spacer(),
          const _ToolbarIcon(icon: Icons.grid_view_rounded),
          const SizedBox(width: 8),
          const _ToolbarIcon(icon: Icons.tune_rounded),
        ],
      ),
    );
  }
}

class _GenreTable extends StatelessWidget {
  const _GenreTable({required this.genres, required this.l10n});

  final List<GenreEntity> genres;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.7,
    );
    final headerStyle = _headerStyle.copyWith(color: headerColor);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              SizedBox(
                width: 100,
                child: Text(
                  l10n.albumHeaderSongs,
                  style: headerStyle,
                  textAlign: .right,
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  l10n.albumCount,
                  style: headerStyle,
                  textAlign: .right,
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return _GenreRow(index: index + 1, genre: genre);
            },
          ),
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

class _GenreRow extends StatelessWidget {
  const _GenreRow({required this.index, required this.genre});

  final int index;
  final GenreEntity genre;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text('$index', style: theme.textTheme.bodySmall),
            ),
            Expanded(
              flex: 4,
              child: Text(
                genre.value ?? '-',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: .bold,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${genre.songCount ?? 0}',
                style: theme.textTheme.bodySmall,
                textAlign: .right,
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${genre.albumCount ?? 0}',
                style: theme.textTheme.bodySmall,
                textAlign: .right,
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(width: 8),
          Icon(icon, size: 16),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant);
  }
}
