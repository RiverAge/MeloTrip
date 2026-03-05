import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class DesktopFoldersPage extends ConsumerWidget {
  const DesktopFoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(title: l10n.songMetaPath, count: 521),
          _Toolbar(),
          Expanded(child: _FolderTable()),
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
              fontWeight: .w900,
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
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Id',
            style: TextStyle(
              fontSize: 12,
              fontWeight: .bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 24),
          Icon(
            Icons.sort_by_alpha_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.refresh_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Spacer(),
          Icon(
            Icons.tune_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _FolderTable extends StatelessWidget {
  final dummyFolders = [
    'A-Lin',
    'Adele',
    'AGA',
    'Aimer',
    'Alan Walker',
    'Alesso',
    'Alex Goot',
    'Arcane',
    'Avicii',
    'Backstreet Boys',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 30, child: Text('#', style: _headerStyle)),
              const Expanded(
                flex: 4,
                child: Text('TITLE', style: _headerStyle),
              ),
              const SizedBox(
                width: 60,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ),
              const Expanded(
                flex: 3,
                child: Text('ALBUM', style: _headerStyle),
              ),
              const Expanded(
                flex: 2,
                child: Text('GENRE', style: _headerStyle),
              ),
              const SizedBox(
                width: 60,
                child: Text('YEAR', style: _headerStyle),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: dummyFolders.length,
            itemBuilder: (context, index) {
              return _FolderRow(index: index + 1, name: dummyFolders[index]);
            },
          ),
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: .bold,
    color: Colors.grey,
    letterSpacing: 1.2,
  );
}

class _FolderRow extends StatelessWidget {
  const _FolderRow({required this.index, required this.name});
  final int index;
  final String name;

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
              child: Row(
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            const Expanded(flex: 3, child: SizedBox()),
            const Expanded(flex: 2, child: SizedBox()),
            const SizedBox(width: 60),
            const Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
