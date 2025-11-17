import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/progress_indicator.dart';

void main() {
  group('GameProgressIndicator', () {
    testWidgets('displays progress text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 15,
              total: 25,
            ),
          ),
        ),
      );

      expect(find.text('15 / 25'), findsOneWidget);
    });

    testWidgets('shows progress bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 10,
              total: 20,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('calculates correct progress percentage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 5,
              total: 10,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 0.5); // 5/10 = 0.5
    });

    testWidgets('handles zero total gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 0,
              total: 0,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 0.0);
    });

    testWidgets('shows 100% progress when current equals total',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 20,
              total: 20,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 1.0);
    });

    testWidgets('has semantic label for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 7,
              total: 10,
            ),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('7 of 10 problems completed'),
        findsOneWidget,
      );
    });

    testWidgets('displays correct text for zero progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameProgressIndicator(
              current: 0,
              total: 25,
            ),
          ),
        ),
      );

      expect(find.text('0 / 25'), findsOneWidget);
    });
  });
}
