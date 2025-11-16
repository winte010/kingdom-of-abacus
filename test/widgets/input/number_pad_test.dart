import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/input/number_pad.dart';

void main() {
  group('NumberPad', () {
    testWidgets('renders all number buttons 0-9', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      for (int i = 0; i <= 9; i++) {
        expect(find.text(i.toString()), findsOneWidget);
      }
    });

    testWidgets('displays question mark initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('updates display when number is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      // Tap number 5
      await tester.tap(find.text('5'));
      await tester.pump();

      expect(find.text('5'), findsNWidgets(2)); // One in button, one in display
    });

    testWidgets('builds multi-digit number', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      // Tap 1, 2, 3
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('delete button removes last digit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      // Type 456
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('6'));
      await tester.pump();

      // Tap delete
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();

      expect(find.text('45'), findsOneWidget);
    });

    testWidgets('submit button calls onSubmit with correct value',
        (tester) async {
      int? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (value) {
                submittedValue = value;
              },
            ),
          ),
        ),
      );

      // Type 42
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();

      // Submit
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(submittedValue, 42);
    });

    testWidgets('clears input after submit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      // Type 7
      await tester.tap(find.text('7'));
      await tester.pump();

      // Submit
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('disables input when enabled is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
              enabled: false,
            ),
          ),
        ),
      );

      // Try to tap number
      await tester.tap(find.text('5'));
      await tester.pump();

      // Should still show question mark
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('submit button is disabled when input is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      final submitButton =
          tester.widget<InkWell>(find.byIcon(Icons.check).first);
      expect(submitButton.onTap, isNull);
    });

    testWidgets('has semantic labels for accessibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Submit'), findsOneWidget);
      expect(find.bySemanticsLabel('Delete'), findsOneWidget);
    });

    testWidgets('calls onDelete callback when delete is pressed',
        (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPad(
              onSubmit: (_) {},
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      // Type a number first
      await tester.tap(find.text('5'));
      await tester.pump();

      // Delete
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });
  });
}
