import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/favorite/favorite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite.g.dart';

@riverpod
class Favorite extends _$Favorite {
  @override
  Future<Result<SubsonicResponse, AppFailure>> build() async {
    final repository = ref.read(favoriteRepositoryProvider);
    return repository.fetchStarredResult();
  }
}
