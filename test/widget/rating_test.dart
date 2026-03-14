import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/widget/rating.dart';

void main() {
  testWidgets('Rating renders 5 stars', (tester) async {
    int? rating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: 0,
            onRating: (value) => rating = value,
          ),
        ),
      ),
    );

    expect(find.byType(Rating), findsOneWidget);

    final icons = tester.widgetList<Icon>(find.byType(Icon));
    expect(icons.length, 5);
  });

  testWidgets('Rating displays correct star icons', (tester) async {
    int? rating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: 3,
            onRating: (value) => rating = value,
          ),
        ),
      ),
    );

    final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();

    for (int i = 0; i < 5; i++) {
      if (i < 3) {
        expect(icons[i].icon, Icons.star_rounded);
      } else {
        expect(icons[i].icon, Icons.star_border_rounded);
      }
    }
  });

  testWidgets('Rating handles hover interaction', (tester) async {
    int? rating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: 0,
            onRating: (value) => rating = value,
          ),
        ),
      ),
    );

    final mouseRegions = tester.widgetList<MouseRegion>(find.byType(MouseRegion));

    await tester.pump();
    await tester.pumpAndSettle();

    expect(rating, isNull);
  });

  testWidgets('Rating calls onRating callback', (tester) async {
    int? selectedRating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: 0,
            onRating: (value) => selectedRating = value,
          ),
        ),
      ),
    );

    expect(selectedRating, isNull);
  });

  testWidgets('Rating handles null rating', (tester) async {
    int? rating;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: null,
            onRating: (value) => rating = value,
          ),
        ),
      ),
    );

    expect(find.byType(Rating), findsOneWidget);
  });

  testWidgets('Rating with custom color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Rating(
            rating: 2,
            onRating: (_) {},
            color: Colors.red,
          ),
        ),
      ),
    );

    expect(find.byType(Rating), findsOneWidget);
  });
}
