import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/ai_chat/chat_message.dart';
import 'package:melo_trip/provider/ai_chat/chat_session.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  void _delete(
    String conversationId,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final navigator = Navigator.of(context);
    await ref.read(
      removeChatCoversationByIdProvider(coversationId: conversationId).future,
    );
    final session = ref.read(chatSessionProvider);
    if (session.id == conversationId) {
      await ref.read(chatSessionProvider.notifier).setSessionById();
    }
    navigator.pop();
  }

  void _onDelete(ChatCoversation data, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.delete),
          content: Text(
            AppLocalizations.of(context)!.deleteConversationConfirm(data.title),
          ),
          actions: [
            TextButton(
              onPressed: () => _delete(data.id, context, ref),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(AppLocalizations.of(context)!.chatHistory),
      ),
      body: AsyncValueBuilder(
        provider: allChatCoversationsProvider,
        builder: (ctx, data, ref) {
          if (data.isEmpty) {
            return const Center(child: NoData());
          }
          return ListView.separated(
            itemBuilder: (_, index) {
              final item = data[index];
              return ListTile(
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await ref
                      .read(chatSessionProvider.notifier)
                      .setSessionById(conversationId: item.id);
                  navigator.pop();
                },

                title: Text(item.title, overflow: TextOverflow.clip),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_outlined),
                  onPressed: () => _onDelete(item, ctx, ref),
                ),
              );
            },
            separatorBuilder: (_, _) => const Divider(),
            itemCount: data.length,
          );
        },
      ),
    );
  }
}
