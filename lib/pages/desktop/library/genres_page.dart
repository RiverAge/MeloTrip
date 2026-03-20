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

    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(title: l10n.songMetaGenre),
          const _Toolbar(),
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
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
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
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text('#', style: headerStyle),
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              Expanded(
                child: Align(
                  alignment: .centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      l10n.albumHeaderSongs,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: headerStyle,
                      textAlign: .right,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: .centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      l10n.albumCount,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: headerStyle,
                      textAlign: .right,
                    ),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
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
    final genreValue = genre.value?.trim();
    return InkWell(
      onTap: genreValue == null || genreValue.isEmpty
          ? null
          : () {
              Navigator.of(
                context,
              ).pushNamed('/genre_detail', arguments: genre);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: .centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 40),
                  child: Text(
                    '$index',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                genre.value ?? '-',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .bold),
              ),
            ),
            Expanded(
              child: Align(
                alignment: .centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    '${genre.songCount ?? 0}',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall,
                    textAlign: .right,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: .centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    '${genre.albumCount ?? 0}',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall,
                    textAlign: .right,
                  ),
                ),
              ),
            ),
            const SizedBox.square(dimension: 16),
          ],
        ),
      ),
    );
  }
}
