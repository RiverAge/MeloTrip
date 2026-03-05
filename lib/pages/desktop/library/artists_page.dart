import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class DesktopArtistsPage extends ConsumerWidget {
  const DesktopArtistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          _PageHeader(
            title: l10n.artist,
            count: 521,
          ),
          _Toolbar(),
          Expanded(
            child: _ArtistGrid(),
          ),
        ],
      ),
    );
  }
}

final artistsProvider = FutureProvider<SubsonicResponse>((ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getArtists');
  return SubsonicResponse.fromJson(res.data!);
});

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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _ToolbarButton(label: '名称', icon: Icons.sort_by_alpha_rounded),
          const SizedBox(width: 16),
          _ToolbarIcon(icon: Icons.refresh_rounded),
          const Spacer(),
          _ToolbarIcon(icon: Icons.grid_view_rounded),
          const SizedBox(width: 8),
          _ToolbarIcon(icon: Icons.tune_rounded),
        ],
      ),
    );
  }
}

class _ArtistGrid extends StatelessWidget {
  final dummyArtists = [
    '伯远', '韩寒', '张铠麟', '丁子高', '谢军', '钟易轩',
    '曾小敏', '周厚安', 'Robin', 'Taylor Swift', '天空之城音乐制作', '信',
    '信泽宣明', '王赫野', '吕薇', '张文成', '张雨生', 'Win and Woo'
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: dummyArtists.length,
      itemBuilder: (context, index) {
        return _ArtistCard(name: dummyArtists[index]);
      },
    );
  }
}

class _ArtistCard extends StatelessWidget {
  const _ArtistCard({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          maxLines: 1,
          overflow: .ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: .bold,
          ),
        ),
      ],
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
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
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
