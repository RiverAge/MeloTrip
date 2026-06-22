import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

void main() {
  testWidgets('showAutoClosingSnackBar closes action snackbar after duration', (
    tester,
  ) async {
    final messengerKey = GlobalKey<ScaffoldMessengerState>();

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: messengerKey,
        home: const MediaQuery(
          data: MediaQueryData(accessibleNavigation: true),
          child: Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );

    showAutoClosingSnackBar(
      messengerKey.currentState!,
      dismissAfter: const Duration(milliseconds: 10),
      snackBar: SnackBar(
        duration: const Duration(days: 1),
        content: const Text('Queue cleared'),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );

    await tester.pump();

    expect(find.text('Queue cleared'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    await tester.pumpAndSettle();

    expect(find.text('Queue cleared'), findsNothing);
  });
}
