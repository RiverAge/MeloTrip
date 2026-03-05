// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:desktop_lyrics/desktop_lyrics.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin channel smoke test', (WidgetTester tester) async {
    final plugin = DesktopLyrics();
    await plugin.apply(
      plugin.state.copyWith(
        interaction: plugin.state.interaction.copyWith(enabled: true),
      ),
    );
    await plugin.render(const DesktopLyricsFrame.line(currentLine: 'Hello'));
    await plugin.apply(
      plugin.state.copyWith(
        interaction: plugin.state.interaction.copyWith(enabled: false),
      ),
    );
    plugin.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(true, isTrue);
  });
}
