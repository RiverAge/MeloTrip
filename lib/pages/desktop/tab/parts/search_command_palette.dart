import 'package:flutter/material.dart';

class SearchCommandPalette extends StatelessWidget {
  const SearchCommandPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        width: 600,
        height: 400,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: .5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .5),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('HOME', style: theme.textTheme.labelSmall?.copyWith(fontWeight: .bold, color: Colors.grey)),
                  const Spacer(),
                  const Icon(Icons.close, size: 16, color: Colors.grey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '搜索...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: .2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                   _CommandTile(title: '搜索...', subtitle: '命令'),
                   _CommandTile(title: '创建 播放列表...', subtitle: ''),
                   _CommandTile(title: '跳至页面...', subtitle: ''),
                   _CommandTile(title: '服务器命令...', subtitle: ''),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: .2))),
              ),
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  _KeyHint(label: 'ESC'),
                  const SizedBox(width: 8),
                  _KeyHint(icon: Icons.arrow_upward_rounded),
                  const SizedBox(width: 8),
                  _KeyHint(icon: Icons.arrow_downward_rounded),
                  const SizedBox(width: 8),
                  _KeyHint(icon: Icons.keyboard_return_rounded),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CommandTile extends StatelessWidget {
  const _CommandTile({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: subtitle != null && subtitle!.isNotEmpty ? Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)) : null,
      onTap: () {},
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({this.label, this.icon});
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.withValues(alpha: .3)),
      ),
      child: label != null 
        ? Text(label!, style: const TextStyle(fontSize: 10, fontWeight: .bold, color: Colors.grey))
        : Icon(icon, size: 10, color: Colors.grey),
    );
  }
}
