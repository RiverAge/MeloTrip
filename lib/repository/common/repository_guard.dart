import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';

Future<Result<T, AppFailure>> runGuarded<T>(Future<T> Function() request) async {
  try {
    final response = await request();
    return Result.ok(response);
  } catch (error, stackTrace) {
    return Result.err(AppFailure.from(error, stackTrace));
  }
}
