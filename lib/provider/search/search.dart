import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

// 1. 原始输入词 (V2 使用)
final searchQueryProvider = StateProvider<String>((ref) => '');

// 2. 核心搜索结果 Provider (V2 使用)
final searchResultProvider = FutureProvider<SubsonicResponse?>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return null;

  await Future.delayed(const Duration(milliseconds: 600));
  if (ref.read(searchQueryProvider) != query) return null;

  return ref.read(searchProvider(query).future);
});

// 3. 兼容层 Provider (V1 使用，同时作为 V2 的核心实现)
final searchProvider = FutureProvider.family<SubsonicResponse?, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return null;

  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/search3',
    queryParameters: {'query': query},
    cancelToken: cancelToken,
  );

  final data = res.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
});
