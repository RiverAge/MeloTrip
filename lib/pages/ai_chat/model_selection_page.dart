import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/ai_chat/chat_model.dart';
import 'package:melo_trip/provider/ai_chat/ai_model.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class ModelSelectionPage extends StatefulWidget {
  const ModelSelectionPage({super.key});

  @override
  State<ModelSelectionPage> createState() => _ModelSelectionPageState();
}

class _ModelSelectionPageState extends State<ModelSelectionPage> {
  // 用于控制搜索框文本
  final TextEditingController _searchController = TextEditingController();
  // 用于触发 UI 重绘的搜索关键词
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // 使用 Material 3 风格的搜索栏嵌入 AppBar
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 19),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  cursorHeight: 17,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    // icon: Icon(Icons.search),
                    hintText: AppLocalizations.of(context)!.searchModels,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: Icon(Icons.clear, size: 19),
              ),
            ],
          ),
        ),
        scrolledUnderElevation: 3.0,
      ),
      body: AsyncValueBuilder(
        provider: availableModelsProvider,
        builder: (context, d, ref) {
          final filteredList = d.where((item) {
            if (_searchQuery.isEmpty) return true;
            final id = item.id?.toLowerCase() ?? '';
            final owner = item.ownedBy?.toLowerCase() ?? '';
            return id.contains(_searchQuery) || owner.contains(_searchQuery);
          }).toList();

          //  Empty State
          if (filteredList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noModelsAvailable,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          final Map<String, List<ChatModel>> groupedData = {};
          for (var item in filteredList) {
            final owner = item.ownedBy;
            if (owner != null) {
              groupedData.putIfAbsent(owner, () => []).add(item);
            }
          }

          final sortedKeys = groupedData.keys.toList()..sort();
          final isDark = theme.brightness == Brightness.dark;
          final iconThemeStr = isDark ? 'dark' : 'light';

          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              for (final key in sortedKeys) ...[
                SliverMainAxisGroup(
                  slivers: [
                    PinnedHeaderSliver(
                      child: _ModelGroupHeader(
                        title: key,
                        logoName: getLogoUriOfProvider(
                          key,
                          iconThemeStr: iconThemeStr,
                        ),
                        count: groupedData[key]!.length, // 传入数量显示
                      ),
                    ),
                    AsyncValueBuilder(
                      provider: userConfigProvider,
                      builder: (context, uc, ref) {
                        return SliverList.separated(
                          itemBuilder: (context, index) {
                            final item = groupedData[key]![index];
                            return _ModelListItem(
                              model: item,
                              groupKey: key,
                              isChecked: item.id == uc.aiModel,
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                await ref
                                    .read(userConfigProvider.notifier)
                                    .setConfiguration(
                                      aiModel: ValueUpdater(item.id),
                                    );
                                navigator.pop();
                              },
                            );
                          },
                          itemCount: groupedData[key]!.length,
                          separatorBuilder: (context, index) => Divider(),
                        );
                      },
                    ),
                  ],
                ),
              ],
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 20,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModelGroupHeader extends StatelessWidget {
  final String title;
  final String? logoName;
  final int count;

  const _ModelGroupHeader({
    required this.title,
    this.logoName,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface, // 必须设置背景色防止透视
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            if (logoName != null)
              Container(
                width: 28,
                height: 28,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: .3),
                  ),
                ),
                child: Image.network(
                  logoName!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.dns_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.folder_open, color: colorScheme.primary),
              ),

            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            // 数量 Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelListItem extends StatelessWidget {
  final ChatModel model;
  final String groupKey;
  final bool isChecked;
  final void Function() onTap;
  const _ModelListItem({
    required this.model,
    required this.groupKey,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayName = model.id?.replaceAll('$groupKey/', '') ?? 'Unknown';

    final dateStr = model.created != null
        ? DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(model.created! * 1000),
          )
        : '';

    return ListTile(
      onTap: onTap,
      title: Text(
        displayName,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: dateStr.isNotEmpty
          ? Text(
              dateStr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: isChecked ? const Icon(Icons.check) : null,
    );
  }
}
