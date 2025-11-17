import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/book/book_page.dart';

void main() {
  group('BookPage', () {
    testWidgets('displays story text', (tester) async {
      const testText = 'Once upon a time in the Kingdom of Abacus...';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: testText,
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('text is scrollable for long content', (tester) async {
      const longText = '''
This is a very long story that will definitely need scrolling.
Line 2
Line 3
Line 4
Line 5
Line 6
Line 7
Line 8
Line 9
Line 10
      ''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: longText,
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has proper text styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: 'Test text',
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test text'));
      expect(textWidget.style?.fontSize, 18);
      expect(textWidget.style?.height, 1.5);
    });

    testWidgets('applies background image when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: 'Story text',
              backgroundImage: 'assets/backgrounds/test.png',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.image, isNotNull);
    });

    testWidgets('has no background image when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: 'Story text',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.decoration, isNull);
    });

    testWidgets('has proper padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookPage(
              text: 'Test',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.padding, const EdgeInsets.all(24));
    });
  });
}
