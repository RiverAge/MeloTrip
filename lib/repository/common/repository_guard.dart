import 'package:melo_trip/helper/app_failure_log.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

Future<Result<T, AppFailure>> runGuarded<T>(
  Future<T> Function() request,
) async {
  try {
    final response = await request();
    return Result.ok(response);
  } on SongNotAnalyzedError catch (error, stackTrace) {
    // Convert SongNotAnalyzedError to AppFailure with notAnalyzed type
    final failure = AppFailure(
      type: AppFailureType.notAnalyzed,
      message: 'Song has not been analyzed by AudioMuse-AI plugin.',
      cause: error,
      stackTrace: stackTrace,
    );
    logAppFailure(failure, scope: 'repository_guard', error: error);
    return Result.err(failure);
  } catch (error, stackTrace) {
    final failure = AppFailure.from(error, stackTrace);
    logAppFailure(failure, scope: 'repository_guard', error: error);
    return Result.err(failure);
  }
}
