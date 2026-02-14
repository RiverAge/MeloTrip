import 'package:melo_trip/model/ai_chat/chat_message.dart';
import 'package:sqflite/sqflite.dart';

class ChatCoversationDb {
  Database db;
  String username;
  ChatCoversationDb({required this.db, required this.username});

  Future<List<ChatCoversation>> getAllCoversation() async {
    return await db.transaction((tnx) async {
      final conversationRows = await tnx.query(
        'ai_chat_conversation',
        where: 'username = ?',
        whereArgs: [username],
        orderBy: 'update_at desc',
      );
      return conversationRows.map((e) => ChatCoversation.fromJson(e)).toList();
    });
  }

  Future<void> saveConversationOnly(ChatCoversation c) async {
    return db.transaction((tnx) async {
      await tnx.insert('ai_chat_conversation', {
        'id': c.id,
        'username': username,
        'title': c.title,
        'update_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> saveMessage({
    required String coversationId,
    required ChatMessage message,
  }) async {
    return db.transaction((tnx) async {
      await tnx.insert('ai_chat_message', {
        ...message.toJson(),
        'conversation_id': coversationId,
        'update_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<ChatCoversation?> getConversationById(String id) async {
    return await db.transaction((tnx) async {
      final conversationRows = await tnx.query(
        'ai_chat_conversation',
        where: 'username = ?',
        whereArgs: [username],
        orderBy: 'update_at desc',
      );

      if (conversationRows.isNotEmpty) {
        final item = Map<String, dynamic>.of(conversationRows.first);
        final messageRows = await tnx.query(
          'ai_chat_message',
          where: 'conversation_id = ?',
          whereArgs: [item['id']],
          orderBy: 'timestamp asc',
        );
        item['messages'] = messageRows;
        return ChatCoversation.fromJson(item);
      }
      return null;
    });
  }

  Future<void> removeCoversation({required String coversationId}) {
    return db.transaction((tnx) async {
      await tnx.delete(
        'ai_chat_message',
        where: "conversation_id = ?",
        whereArgs: [coversationId],
      );
      await tnx.delete(
        'ai_chat_conversation',
        where: "id = ?",
        whereArgs: [coversationId],
      );
    });
  }
}
