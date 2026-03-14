import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

void main() {
  testWidgets('FixedCenterCircular renders with default size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(),
        ),
      ),
    );

    expect(find.byType(FixedCenterCircular), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, 20);
    expect(sizedBox.height, 20);
  });

  testWidgets('FixedCenterCircular renders with custom size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(size: 40, strokeWidth: 4),
        ),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, 40);
    expect(sizedBox.height, 40);

    final circularProgress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(circularProgress.strokeWidth, 4);
  });

  testWidgets('FixedCenterCircular centers content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FixedCenterCircular(),
        ),
      ),
    );

    expect(find.byType(Center), findsOneWidget);
  });
}
