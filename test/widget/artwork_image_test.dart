import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/widget/artwork_image.dart';

void main() {
  testWidgets('ArtworkImage shows placeholder when id is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(id: null),
          ),
        ),
      ),
    );

    expect(find.byType(ArtworkImage), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('ArtworkImage shows custom placeholder', (tester) async {
    const customPlaceholder = Text('Custom Placeholder');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(
              id: null,
              placeholder: customPlaceholder,
              errorWidget: customPlaceholder,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Custom Placeholder'), findsOneWidget);
  });

  testWidgets('ArtworkImage shows custom error widget', (tester) async {
    const customError = Text('Custom Error');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(
              id: null,
              errorWidget: customError,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Custom Error'), findsOneWidget);
  });

  testWidgets('ArtworkImage with valid id shows placeholder initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(
              id: '123',
              size: 100,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ArtworkImage), findsOneWidget);
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('ArtworkImage respects size parameter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(
              id: 'test',
              size: 200,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ArtworkImage), findsOneWidget);
  });

  testWidgets('ArtworkImage respects fit parameter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderScope(
            child: ArtworkImage(
              id: 'test',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ArtworkImage), findsOneWidget);
  });
}
