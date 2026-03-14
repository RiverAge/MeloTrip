import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

void main() {
  testWidgets('FixedCenterCircular renders CircularProgressIndicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(),
        ),
      ),
    );

    expect(find.byType(FixedCenterCircular), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FixedCenterCircular uses default size and strokeWidth', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(),
        ),
      ),
    );

    final widget = tester.widget<FixedCenterCircular>(
      find.byType(FixedCenterCircular),
    );
    expect(widget.size, equals(20));
    expect(widget.strokeWidth, equals(2));
  });

  testWidgets('FixedCenterCircular uses custom size and strokeWidth', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(size: 40, strokeWidth: 4),
        ),
      ),
    );

    final widget = tester.widget<FixedCenterCircular>(
      find.byType(FixedCenterCircular),
    );
    expect(widget.size, equals(40));
    expect(widget.strokeWidth, equals(4));
  });

  testWidgets('FixedCenterCircular centers the CircularProgressIndicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(),
        ),
      ),
    );

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
