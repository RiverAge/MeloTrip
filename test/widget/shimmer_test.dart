import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/shimmer.dart';

void main() {
  group('Shimmer', () {
    testWidgets('renders ShimmerBox children without throwing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Shimmer(
              child: Column(
                children: [
                  ShimmerBox(width: 120, height: 18),
                  SizedBox(height: 8),
                  ShimmerBox(width: 80, height: 12, borderRadius: 4),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerBox), findsNWidgets(2));
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('ShimmerBox renders as plain block without Shimmer ancestor',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(width: 50, height: 50),
          ),
        ),
      );

      // Should still render a SizedBox + DecoratedBox without crashing.
      expect(find.byType(ShimmerBox), findsOneWidget);
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    testWidgets('animates without errors across frames', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 20,
              child: Shimmer(child: ShimmerBox()),
            ),
          ),
        ),
      );

      // Pump a few frames to exercise the repeating AnimationController.
      // No pumpAndSettle: the controller repeats forever, so the animation
      // never settles.
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));

      expect(tester.takeException(), isNull);
    });
  });
}
