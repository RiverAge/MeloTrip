import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/guesture_hint.dart';

void main() {
  testWidgets('GestureHint renders expected size and themed color', (
    tester,
  ) async {
    const expectedColor = Color(0xFF336699);
    final theme = ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
        onSurfaceVariant: expectedColor,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(body: Center(child: GestureHint())),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(container.constraints, isNotNull);
    expect(container.constraints!.maxWidth, 40);
    expect(container.constraints!.maxHeight, 5);
    expect(container.constraints!.minWidth, 40);
    expect(container.constraints!.minHeight, 5);
    expect(container.margin, const EdgeInsets.only(top: 8));
    expect(decoration.color, expectedColor.withAlpha(50));
    expect(
      decoration.borderRadius,
      const BorderRadius.all(Radius.circular(20)),
    );
  });
}
