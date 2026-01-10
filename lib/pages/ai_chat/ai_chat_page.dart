import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/ai_chat/conversation_page.dart';
import 'package:melo_trip/pages/settings/ai_config_page.dart';
import 'package:melo_trip/pages/ai_chat/widgets/message_bubble.dart';
import 'package:melo_trip/pages/ai_chat/widgets/message_input.dart';
import 'package:melo_trip/pages/ai_chat/model_selection_page.dart';
import 'package:melo_trip/provider/ai_chat/chat_session.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final ScrollController _scrollController = ScrollController();
  // bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final distanceFromBottom = position.maxScrollExtent - position.pixels;

    if (distanceFromBottom < 80) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(position.maxScrollExtent);
      });
    }
  }

  Future<void> _onSendMessage(String content) async {
    ref.read(chatSessionProvider.notifier).send(content: content);
  }

  Future<void> _onStop() async {
    ref.read(chatSessionProvider.notifier).stop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(chatSessionProvider.select((s) => s.messages), (prev, next) {
      final prevLen = prev?.length ?? 0;
      final nextLen = next.length;
      if (nextLen > prevLen) {
        _scrollToBottom();
      } else if ((prev ?? []).isNotEmpty &&
          next.isNotEmpty &&
          (next.last.reasoningContent ?? '').length + next.last.content.length >
              (prev?.last.reasoningContent ?? '').length +
                  (prev?.last.content ?? '').length) {
        _scrollToBottom();
      }
    });

    return AsyncValueBuilder(
      provider: userConfigProvider,
      builder: (context, uc, _) {
        final isAiApiConfiged = uc.aiApiUrl != null;
        final isAiModelConfiged = uc.aiModel != null;

        final data = ref.watch(chatSessionProvider);
        final messages = data.messages;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title == ''
                      ? AppLocalizations.of(context)!.aiChat
                      : data.title,
                ),
                if (isAiApiConfiged)
                  Text(
                    isAiModelConfiged
                        ? uc.aiModel ?? '-'
                        : AppLocalizations.of(context)!.noModelSelected,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
            actions: isAiApiConfiged
                ? [
                    if (messages.length >= 2 && !messages.last.isStreaming)
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          ref
                              .read(chatSessionProvider.notifier)
                              .setSessionById();
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConversationPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ModelSelectionPage(),
                          ),
                        );
                      },
                    ),
                  ]
                : null,
          ),
          body: isAiApiConfiged
              ? isAiModelConfiged
                    ? Column(
                        children: [
                          Expanded(
                            child: messages.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.only(bottom: 16),
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      final message = messages[index];
                                      return MessageBubble(message: message);
                                    },
                                  ),
                          ),
                          MessageInput(
                            onSend: _onSendMessage,
                            onStop: _onStop,
                            isLoading:
                                messages.isNotEmpty &&
                                messages.last.isStreaming,
                          ),
                        ],
                      )
                    : _buildNoModel()
              : _buildNoApiKey(),
        );
      },
    );
  }

  Widget _buildNoApiKey() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.smart_toy_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.aiNeedConfig),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              // 跳转到你刚才写的配置页
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiConfigPage()),
              );
            },
            child: Text(AppLocalizations.of(context)!.goToConfig),
          ),
        ],
      ),
    );
  }

  Widget _buildNoModel() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.smart_toy_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.selectModelToStart),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              // 跳转到你刚才写的配置页
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModelSelectionPage()),
              );
            },
            child: Text(AppLocalizations.of(context)!.goToConfig),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.startConversation,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.askMeAnything,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip(l10n.tellMeJoke, Icons.emoji_emotions),
                _buildSuggestionChip(l10n.explainQuantumPhysics, Icons.science),
                _buildSuggestionChip(l10n.writePoem, Icons.edit),
                _buildSuggestionChip(l10n.helpMeCode, Icons.code),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      onPressed: () => _onSendMessage(text),
    );
  }
}
