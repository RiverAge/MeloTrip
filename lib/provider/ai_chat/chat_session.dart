import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/ai_chat/chat_completion_chunk.dart';
import 'package:melo_trip/model/ai_chat/chat_message.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_database/app_database.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/repository/ai_chat/chat_api.dart';
import 'package:melo_trip/repository/ai_chat/conversation_db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_session.g.dart';

@riverpod
Future<List<ChatCoversation>> allChatCoversations(Ref ref) async {
  final db = await ref.read(appDatabaseProvider.future);
  final authUser = await ref.read(currentUserProvider.future);

  final userId = authUser?.id;
  if (userId == null) return [];

  final cr = ChatCoversationDb(db: db, userId: userId);

  return cr.getAllCoversation();
}

@riverpod
Future<void> removeChatCoversationById(
  Ref ref, {
  required String coversationId,
}) async {
  final db = await ref.read(appDatabaseProvider.future);
  final authUser = await ref.read(currentUserProvider.future);

  final userId = authUser?.id;
  if (userId == null) return;

  final cr = ChatCoversationDb(db: db, userId: userId);
  await cr.removeCoversation(coversationId: coversationId);
  ref.invalidate(allChatCoversationsProvider);
}

@Riverpod(keepAlive: true)
class ChatSession extends _$ChatSession {
  @override
  ChatCoversation build() {
    /**
     * 用户推出处理
     */
    final cu = ref.watch(currentUserProvider);
    final userId = cu.valueOrNull?.id;
    if (userId == null) {
      _cancelToken?.cancel('ERR_USER_LOGGED_OUT');
      return ChatCoversation.create();
    }

    return ChatCoversation.create();
  }

  Future<ChatCoversation?> setSessionById({String? conversationId}) async {
    final db = await ref.read(appDatabaseProvider.future);
    final authUser = await ref.read(currentUserProvider.future);

    final userId = authUser?.id;
    if (userId == null) return null;

    final cr = ChatCoversationDb(db: db, userId: userId);

    if (conversationId == null) {
      state = ChatCoversation.create();
      return state;
    }

    final ret = await cr.getConversationById(conversationId);
    if (ret == null) return null;
    state = ret;
    return ret;
  }

  CancelToken? _cancelToken;
  void send({required String content}) async {
    final api = await ref.read(apiProvider.future);
    final db = await ref.read(appDatabaseProvider.future);
    final uc = await ref.read(userConfigProvider.future);
    final authUser = await ref.read(currentUserProvider.future);
    final userId = authUser?.id;
    final model = uc?.aiModel;

    if (userId == null || model == null) {
      return;
    }

    final acr = ChatApi(api: api);
    final cr = ChatCoversationDb(db: db, userId: userId);

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage.create(
          isStreaming: false,
          model: model,
          content: content,
          role: MessageRole.user,
        ),
      ],
    );

    DateTime? thinkingStart;
    DateTime? totalStart;

    // 1. 【关键】防抖/清理
    // 如果上一次请求还在跑（比如用户手快连点了两次，或者上一条还没生成完就发下一条）
    // 先把上一次的取消掉，保证同一时间只有一个请求在跑
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("ERR_CANCELLED_BY_NEW_REQ");
    }

    // 2. 【核心】生成一个新的 Token
    // 必须在这里 new，不能复用旧的
    _cancelToken = CancelToken();

    final stream = acr.send(
      model: model,
      coversation: state,
      cancelToken: _cancelToken,
    );
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage.create(
          isStreaming: true,
          model: model,
          content: '',
          role: MessageRole.assistant,
        ),
      ],
    );

    try {
      await for (var choice
          in stream.where((e) => e != null).cast<ChatCompletionChunkChoice>()) {
        final ChatCompletionChunkChoice(:delta, :finishReason) = choice;
        final content = delta?.content;
        final reason = delta?.reasoningContent;

        // 3. 准备工作：获取当前的消息列表和最后一条消息
        // 拿到最后一条消息的副本作为“草稿”
        var messages = state.messages;
        var lastMsg = state.messages.last;
        bool hasChanges = false; // 标记是否发生了变化

        // --- 逻辑处理开始 ---

        // A. 处理思考过程 (Reasoning)
        if (reason != null && reason.isNotEmpty) {
          totalStart ??= DateTime.now();
          thinkingStart ??= DateTime.now(); // 记录思考开始时间
          lastMsg = lastMsg.copyWith(
            reasoningContent: (lastMsg.reasoningContent ?? '') + reason,
          );
          hasChanges = true;
        }

        // B. 处理正文内容 (Content)
        if (content != null && content.isNotEmpty) {
          totalStart ??= DateTime.now();
          // 核心逻辑：如果开始输出正文了，且之前在思考，则计算思考耗时
          Duration? duration = lastMsg.reasoningDuration;
          if (thinkingStart != null && duration == null) {
            duration = DateTime.now().difference(thinkingStart);
          }

          lastMsg = lastMsg.copyWith(
            content: lastMsg.content + content,
            reasoningDuration: duration,
          );
          hasChanges = true;
        }

        // C. 处理结束状态 (Finish)
        if (finishReason != null && finishReason.isNotEmpty) {
          Duration? totalDuration;
          if (totalStart != null) {
            totalDuration = DateTime.now().difference(totalStart);
          }
          lastMsg = lastMsg.copyWith(
            isStreaming: false,
            totalDuration: totalDuration,
          );

          hasChanges = true;
        }

        // --- 逻辑处理结束 ---

        // 4. 提交更新：只有当确实有变化时，才触发 Riverpod 更新
        if (hasChanges) {
          // 这是一个极其高效的列表替换操作：复制前 N-1 个 + 新的最后一个
          final newMessages = List<ChatMessage>.from(messages);
          newMessages[newMessages.length - 1] = lastMsg;
          state = state.copyWith(messages: newMessages);
        } else {
          continue;
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        final newMessages = List<ChatMessage>.from(state.messages);
        newMessages[newMessages.length - 1] = state.messages.last.copyWith(
          isStreaming: false,
          error: (e.error as String),
        );
        state = state.copyWith(messages: newMessages);
      }
    }
    // 一轮对话之后才入库会话
    if (state.messages.length == 2) {
      await cr.saveConversationOnly(state);
    }
    // 有了回复之后才把对话入库
    if (state.messages.length >= 2) {
      await cr.saveMessage(
        coversationId: state.id,
        message: state.messages[state.messages.length - 2],
      );
      await cr.saveMessage(
        coversationId: state.id,
        message: state.messages.last,
      );
      if (state.title == '') {
        acr.summarize(model: model, coversation: state).then((title) {
          if (title != null) {
            state = state.copyWith(title: title);
            cr.saveConversationOnly(state);
          }
        });
      }
    }
  }

  // 手动停止生成（绑定给 UI 的停止按钮）
  void stop() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("ERR_CANCELLED_BY_USER_STOP");
      // 注意：这里 cancel 后，sendMessageStream 会抛出异常进入 catch 块
      // 逻辑会在那边结束
    }
  }
}
