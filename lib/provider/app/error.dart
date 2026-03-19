import 'package:melo_trip/model/common/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error.g.dart';

class AppErrorEvent {
  const AppErrorEvent({
    required this.id,
    required this.message,
    this.failureType,
    this.endpoint,
    this.requestId,
  });

  final int id;
  final String message;
  final AppFailureType? failureType;
  final String? endpoint;
  final String? requestId;
}

@Riverpod(keepAlive: true)
class AppErrorNotifier extends _$AppErrorNotifier {
  int _nextId = 0;

  @override
  AppErrorEvent? build() => null;

  void emit(
    String message, {
    AppFailureType? failureType,
    String? endpoint,
    String? requestId,
  }) {
    if (message.isEmpty) {
      return;
    }

    state = AppErrorEvent(
      id: ++_nextId,
      message: message,
      failureType: failureType,
      endpoint: endpoint,
      requestId: requestId,
    );
  }

  void emitFailure(AppFailure failure) {
    emit(
      failure.message,
      failureType: failure.type,
      endpoint: failure.endpoint,
      requestId: failure.requestId,
    );
  }
}
