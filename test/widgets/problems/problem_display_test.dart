import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/models/problem.dart';
import 'package:kingdom_of_abacus/widgets/problems/problem_display.dart';

void main() {
  group('ProblemDisplay', () {
    testWidgets('displays addition problem text', (tester) async {
      final problem = Problem.addition(7, 8);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      expect(find.text('7 + 8 = ?'), findsOneWidget);
    });

    testWidgets('displays subtraction problem text', (tester) async {
      final problem = Problem.subtraction(10, 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      expect(find.text('10 - 3 = ?'), findsOneWidget);
    });

    testWidgets('displays multiplication problem text', (tester) async {
      final problem = Problem.multiplication(5, 6);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      expect(find.text('5 × 6 = ?'), findsOneWidget);
    });

    testWidgets('displays division problem text', (tester) async {
      final problem = Problem.division(12, 4);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      expect(find.text('12 ÷ 4 = ?'), findsOneWidget);
    });

    testWidgets('has semantic label for accessibility', (tester) async {
      final problem = Problem.addition(5, 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('5 plus 3 equals what?'),
        findsOneWidget,
      );
    });

    testWidgets('uses custom style when provided', (tester) async {
      final problem = Problem.addition(2, 3);
      const customStyle = TextStyle(fontSize: 72, color: Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(
              problem: problem,
              style: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('2 + 3 = ?'));
      expect(textWidget.style?.fontSize, 72);
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('is properly centered', (tester) async {
      final problem = Problem.addition(1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProblemDisplay(problem: problem),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('1 + 1 = ?'));
      expect(textWidget.textAlign, TextAlign.center);
    });
  });
}
