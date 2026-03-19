import 'package:melo_trip/helper/app_failure_log.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';

Future<Result<T, AppFailure>> runGuarded<T>(
  Future<T> Function() request,
) async {
  try {
    final response = await request();
    return Result.ok(response);
  } catch (error, stackTrace) {
    final failure = AppFailure.from(error, stackTrace);
    logAppFailure(failure, scope: 'repository_guard', error: error);
    return Result.err(failure);
  }
}
