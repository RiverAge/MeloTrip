import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:melo_trip/model/ai_chat/chat_completion_chunk.dart';
import 'package:melo_trip/model/ai_chat/chat_message.dart';

class ChatApi {
  Dio api;
  ChatApi({required this.api});

  Future<String?> summarize({
    required String model,
    required ChatCoversation coversation,
  }) async {
    if (coversation.messages.length < 2) {
      return null;
    }
    final prompt =
        '''
        请根据以下对话内容，生成一个简短的会话标题。
        要求：
        1. 不超过 10 个字。
        2. 直接返回标题文本，不要包含引号、标点符号或其他解释性文字。
        3. 概括对话的核心主题。
        4. 使用对话所使用的语言。

        用户：${coversation.messages[coversation.messages.length - 2].content}
        AI：${coversation.messages.last.content}
        ''';

    final res = await api.post<Map<String, dynamic>>(
      '/chat/completions',
      data: {
        "model": model,
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "stream": false, // 🔥 关键：不要流式
      },
      options: Options(extra: {'ai-chat': '1'}),
    );

    final data = res.data;
    if (data == null) {
      return null;
    }

    final chunk = ChatCompletionChunk.fromJson(data);
    final choices = chunk.choices;
    if (choices == null || choices.isEmpty) {
      return null;
    }
    final title = choices[0].message?.content;
    if (title == null) {
      return null;
    }
    return title;
  }

  Stream<ChatCompletionChunkChoice?> send({
    required String model,
    required ChatCoversation coversation,
    CancelToken? cancelToken,
  }) async* {
    final res = await api.post<ResponseBody>(
      '/chat/completions',
      data: {
        "model": model,
        "messages": coversation.messages
            .map((e) => {"role": e.role.name, "content": e.content})
            .toList(),
        "stream": true,
      },
      cancelToken: cancelToken,
      options: Options(
        extra: {'ai-chat': '1'},
        responseType: ResponseType.stream,
      ),
    );
    final Stream<Uint8List>? stream = res.data?.stream;
    if (stream == null) {
      return;
    }

    await for (final line
        in stream
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (line.trim().isEmpty) continue;
      if (!line.startsWith('data: ')) {
        continue;
      }
      final data = line.substring(6).trim();
      if (data == '[DONE]') break;

      final chunk = ChatCompletionChunk.fromJson(jsonDecode(data));
      final choice = chunk.choices?.firstOrNull;

      if (choice == null) continue;

      yield choice;
    }
  }
}
