import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error.g.dart';

class AppErrorEvent {
  const AppErrorEvent({required this.id, required this.message});

  final int id;
  final String message;
}

@Riverpod(keepAlive: true)
class AppErrorNotifier extends _$AppErrorNotifier {
  int _nextId = 0;

  @override
  AppErrorEvent? build() => null;

  void emit(String message) {
    if (message.isEmpty) {
      return;
    }

    state = AppErrorEvent(id: ++_nextId, message: message);
  }
}
