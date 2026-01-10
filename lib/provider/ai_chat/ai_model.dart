import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/ai_chat/chat_model.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_model.g.dart';

@riverpod
Future<List<ChatModel>> availableModels(Ref ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get(
    '/models',
    options: Options(extra: {'ai-chat': '1'}),
  );
  if (res.data != null &&
      res.data['object'] == 'list' &&
      res.data['data'] != null) {
    final ret = (res.data['data'] as List)
        .map((e) => ChatModel.fromJson(e))
        .toList();
    return ret;
  }
  return [];
}
