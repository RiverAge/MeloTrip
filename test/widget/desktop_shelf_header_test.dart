import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_shelf_header.dart';

void main() {
  group('DesktopShelfHeader', () {
    testWidgets('renders title and conditional buttons', (tester) async {
      var refreshTapped = false;
      var viewAllTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesktopShelfHeader(
              title: 'Guess You Like',
              onRefresh: () => refreshTapped = true,
              refreshTooltip: 'refresh',
              onViewAll: () => viewAllTapped = true,
              viewAllTooltip: 'view all',
              onScrollBack: () {},
              onScrollForward: () {},
            ),
          ),
        ),
      );

      expect(find.text('Guess You Like'), findsOneWidget);
      // view-all, refresh, scroll-back, scroll-forward all present.
      expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(
        find.byIcon(Icons.arrow_back_ios_new_rounded),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.arrow_forward_ios_rounded),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.refresh_rounded));
      expect(refreshTapped, isTrue);
      await tester.tap(find.byIcon(Icons.open_in_full_rounded));
      expect(viewAllTapped, isTrue);
    });

    testWidgets('hides trailing buttons when callbacks are null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DesktopShelfHeader(title: 'Only Title'),
          ),
        ),
      );

      expect(find.text('Only Title'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_full_rounded), findsNothing);
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);
      expect(
        find.byIcon(Icons.arrow_back_ios_new_rounded),
        findsNothing,
      );
      expect(
        find.byIcon(Icons.arrow_forward_ios_rounded),
        findsNothing,
      );
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DesktopShelfHeader(
              title: 'Today',
              icon: Icons.today_rounded,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.today_rounded), findsOneWidget);
    });

    testWidgets('play-all button disabled while refreshing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesktopShelfHeader(
              title: 'Today',
              isRefreshing: true,
              onPlayAll: () {},
              playAllTooltip: 'play',
            ),
          ),
        ),
      );

      // play button exists but is disabled (onPressed null) while refreshing.
      final button = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.play_arrow_rounded),
      );
      expect(button.onPressed, isNull);
    });
  });
}
