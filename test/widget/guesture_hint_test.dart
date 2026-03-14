import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/guesture_hint.dart';

void main() {
  testWidgets('GestureHint renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureHint(),
        ),
      ),
    );

    expect(find.byType(GestureHint), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    final container = tester.widget<Container>(find.byType(Container));
    expect(container.margin, isNotNull);
  });

  testWidgets('GestureHint has correct dimensions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureHint(),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    expect(container.constraints?.maxHeight, equals(5.0));
    expect(container.constraints?.maxWidth, equals(40.0));
  });

  testWidgets('GestureHint has rounded border', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureHint(),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, isNotNull);
  });
}
