import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/effects/correct_animation.dart';

void main() {
  group('CorrectAnimation', () {
    testWidgets('displays green check icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('check icon is green', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
      expect(icon.color, Colors.green);
    });

    testWidgets('has circular container with green background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byIcon(Icons.check_circle),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(
        decoration.color,
        Colors.green.withValues(alpha: 0.3),
      );
    });

    testWidgets('has scale transition animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      expect(find.byType(ScaleTransition), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(CorrectAnimation),
          matching: find.byType(ScaleTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('calls onComplete callback when animation finishes',
        (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );

      // Wait for animation to complete (600ms)
      await tester.pump(const Duration(milliseconds: 700));

      expect(completed, isTrue);
    });

    testWidgets('has correct container dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byIcon(Icons.check_circle),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.maxWidth, 200);
      expect(container.constraints?.maxHeight, 200);
    });

    testWidgets('icon has correct size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CorrectAnimation(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
      expect(icon.size, 100);
    });
  });
}
