import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/effects/incorrect_shake.dart';

void main() {
  group('IncorrectShake', () {
    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Text('Wrong answer'),
            ),
          ),
        ),
      );

      expect(find.text('Wrong answer'), findsOneWidget);
    });

    testWidgets('wraps child in AnimatedBuilder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('uses Transform.translate for shake effect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Check that Transform is present
      expect(
        find.ancestor(
          of: find.text('Test'),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );
    });

    testWidgets('maintains child visibility throughout animation',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Initially visible
      expect(find.text('Test'), findsOneWidget);

      // During animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Test'), findsOneWidget);

      // After animation
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles complex child widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Column(
                children: const [
                  Text('Line 1'),
                  Text('Line 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
    });

    testWidgets('animation completes without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncorrectShake(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Pump through entire animation (400ms)
      await tester.pump(const Duration(milliseconds: 500));

      // Should still be visible
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('can handle multiple simultaneous instances', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                IncorrectShake(child: Text('Widget 1')),
                IncorrectShake(child: Text('Widget 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Widget 1'), findsOneWidget);
      expect(find.text('Widget 2'), findsOneWidget);
      expect(find.byType(IncorrectShake), findsNWidgets(2));
    });
  });
}
