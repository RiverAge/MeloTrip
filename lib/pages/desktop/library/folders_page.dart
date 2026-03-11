import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

/// Simple data class for an index artist/folder entry from getIndexes.
class _IndexEntry {
  const _IndexEntry({required this.id, required this.name});
  final String id;
  final String name;
}

/// Provider that fetches folder listing via Subsonic getIndexes API.
final folderIndexesProvider =
    FutureProvider<List<_IndexEntry>>((ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getIndexes');
  final data = res.data;
  if (data == null) return [];

  final indexes =
      data['subsonic-response']?['indexes']?['index'] as List<dynamic>? ?? [];
  final entries = <_IndexEntry>[];
  for (final idx in indexes) {
    final artists = idx['artist'] as List<dynamic>? ?? [];
    for (final artist in artists) {
      final id = artist['id']?.toString() ?? '';
      final name = artist['name']?.toString() ?? '';
      if (id.isNotEmpty) {
        entries.add(_IndexEntry(id: id, name: name));
      }
    }
  }
  return entries;
});

class DesktopFoldersPage extends ConsumerWidget {
  const DesktopFoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AsyncValueBuilder(
            provider: folderIndexesProvider,
            loading: (_, _) => _PageHeader(
              title: l10n.folder,
              count: 0,
            ),
            builder: (context, data, _) {
              return _PageHeader(title: l10n.folder, count: data.length);
            },
          ),
          _Toolbar(l10n: l10n),
          Expanded(
            child: AsyncValueBuilder(
              provider: folderIndexesProvider,
              builder: (context, data, _) {
                return _FolderTable(entries: data, l10n: l10n);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
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
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            l10n.id,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 24),
          Icon(Icons.sort_by_alpha_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Icon(Icons.refresh_rounded, size: 18, color: iconColor),
          const Spacer(),
          Icon(Icons.tune_rounded, size: 18, color: iconColor),
        ],
      ),
    );
  }
}

class _FolderTable extends StatelessWidget {
  const _FolderTable({required this.entries, required this.l10n});
  final List<_IndexEntry> entries;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: .7);
    final headerStyle = _headerStyle.copyWith(color: headerColor);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(
                flex: 4,
                child: Text(l10n.title, style: headerStyle),
              ),
              SizedBox(
                width: 60,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: headerColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(l10n.album, style: headerStyle),
              ),
              Expanded(
                flex: 2,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              SizedBox(
                width: 60,
                child: Text(l10n.songMetaYear, style: headerStyle),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: .3),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _FolderRow(index: index + 1, entry: entries[index]);
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

class _FolderRow extends StatelessWidget {
  const _FolderRow({required this.index, required this.entry});
  final int index;
  final _IndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // TODO: Navigate into folder to show sub-entries
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Icon(
                    Icons.folder_rounded,
                    color: theme.colorScheme.secondary.withValues(alpha: .85),
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            const Expanded(flex: 3, child: SizedBox()),
            const Expanded(flex: 2, child: SizedBox()),
            const SizedBox(width: 60),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
