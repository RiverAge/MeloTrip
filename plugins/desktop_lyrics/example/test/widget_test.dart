// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:desktop_lyrics_example/main.dart';

void main() {
  testWidgets('renders example controls', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Desktop Lyrics Full Demo'), findsOneWidget);
    expect(find.text('Show'), findsOneWidget);
    expect(find.text('Hide'), findsOneWidget);
    expect(find.text('Apply Config'), findsOneWidget);
    expect(find.text('Play Line Preview'), findsOneWidget);
    expect(find.text('Play Token Preview'), findsOneWidget);
  });
}
