import 'dart:async';

/// Serializer for interruption side effects.
/// Ensures side effects from multiple interruption events are executed
/// in the order they were received, even if events arrive rapidly.
///
/// This is similar to AppPlayerCommandSerializer but is kept separate
/// to avoid deadlock when pause/play (which use their own serializer)
/// are called from within interruption handling.
class InterruptionSideEffectSerializer {
  Future<void> _tail = Future<void>.value();

  /// Runs an action in order, waiting for previous actions to complete.
  /// Returns a Future that completes when the action finishes.
  Future<void> run(Future<void> Function() action) {
    final completer = Completer<void>();
    _tail = _tail.catchError((_) {}).then((_) async {
      try {
        await action();
        completer.complete();
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
