import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
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

  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/search3',
    queryParameters: {'query': query},
    cancelToken: cancelToken,
  );

  final data = res.data;
  if (data != null) {
    final config = await ref.read(userConfigProvider.future);
    final recentSearches = (config?.recentSearches ?? '').split(',');
    recentSearches.add(query);
    ref
        .read(userConfigProvider.notifier)
        .setConfiguration(
          recentSearches: ValueUpdater(recentSearches.join(',')),
        );
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
