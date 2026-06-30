import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Overflow guard for widget tests.
///
/// By default, `RenderFlex overflow` and other rendering `FlutterError`s only
/// print to the console — they do **not** fail the test (they are not surfaced
/// via `tester.takeException()`). This guard installs a `FlutterError.onError`
/// that records every `FlutterErrorDetails` so a test can assert none occurred.
///
/// Usage in a test file:
/// ```dart
/// void main() {
///   setUpOverflowGuard();
///   testWidgets(..., (tester) async {
///     ...
///     expectNoFlutterErrors();
///   });
/// }
/// ```
///
/// The original handler is restored automatically via `addTearDown`.

List<FlutterErrorDetails> _recordedErrors = const [];

/// Install the overflow guard for the current test file.
///
/// Call this at the top of `main()` (it registers a `setUp`/`tearDown` pair).
/// Each `setUp` resets the recorded-errors list so tests do not bleed into
/// each other.
void setUpOverflowGuard() {
  setUp(() {
    _recordedErrors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    // Capture the original handler so we can both forward to it (preserving
    // the default console output) and restore it afterwards.
    FlutterError.onError = (details) {
      _recordedErrors.add(details);
      FlutterError.presentError(details);
    };
    addTearDown(() {
      FlutterError.onError = previous;
    });
  });
}

/// Assert that no `FlutterError` (including `RenderFlex overflow`) was reported
/// since the last `setUp`. Call at the end of a `testWidgets` body.
void expectNoFlutterErrors() {
  if (_recordedErrors.isEmpty) return;
  final count = _recordedErrors.length;
  final summary = _recordedErrors.map((e) => e.exception).join('\n');
  // Clear so a subsequent assertion in the same test does not double-report.
  _recordedErrors = const [];
  fail(
    'Expected no FlutterError during rendering, but got $count:\n$summary',
  );
}
