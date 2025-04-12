import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/search/search_history.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search.g.dart';

@riverpod
Future<SubsonicResponse?> search(Ref ref, String query) async {
  if (query == '') {
    return null;
  }

  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  await Future<void>.delayed(const Duration(milliseconds: 650));
  if (didDispose) {
    throw Exception('Cancelled');
  }

  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  final res = await Http.get<Map<String, dynamic>>('/rest/search3',
      queryParameters: {'query': query}, cancelToken: cancelToken);

  final data = res?.data;
  if (data != null) {
    ref.read(searchHistoryProvider.notifier).insertHistory(query);

    return SubsonicResponse.fromJson(data);
  }
  return null;
}
