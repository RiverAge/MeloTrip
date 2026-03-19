import 'package:melo_trip/model/common/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error.g.dart';

class AppErrorEvent {
  const AppErrorEvent({
    required this.id,
    required this.message,
    this.failureType,
  });

  final int id;
  final String message;
  final AppFailureType? failureType;
}

@Riverpod(keepAlive: true)
class AppErrorNotifier extends _$AppErrorNotifier {
  int _nextId = 0;

  @override
  AppErrorEvent? build() => null;

  void emit(String message, {AppFailureType? failureType}) {
    if (message.isEmpty) {
      return;
    }

    state = AppErrorEvent(
      id: ++_nextId,
      message: message,
      failureType: failureType,
    );
  }

  void emitFailure(AppFailure failure) {
    emit(failure.message, failureType: failure.type);
  }
}
