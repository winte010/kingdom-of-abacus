import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/gameplay/timer_display.dart';

void main() {
  group('TimerDisplay', () {
    testWidgets('displays initial time', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 10),
              autoStart: false,
            ),
          ),
        ),
      );

      expect(find.text('10s'), findsOneWidget);
    });

    testWidgets('shows timer icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 5),
              autoStart: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('displays green color when time > 7 seconds',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 10),
              autoStart: false,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.timer));
      expect(icon.color, Colors.green);
    });

    testWidgets('has semantic label for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 5),
              autoStart: false,
            ),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('5 seconds remaining'),
        findsOneWidget,
      );
    });

    testWidgets('calls onExpired when timer reaches zero', (tester) async {
      bool expired = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: const Duration(seconds: 1),
              onExpired: () {
                expired = true;
              },
            ),
          ),
        ),
      );

      // Wait for timer to expire
      await tester.pump(const Duration(seconds: 2));

      expect(expired, isTrue);
    });

    testWidgets('auto-starts when autoStart is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 5),
              autoStart: true,
            ),
          ),
        ),
      );

      // Wait 1 second
      await tester.pump(const Duration(seconds: 1));

      // Should show 4 seconds (5 - 1)
      expect(find.text('4s'), findsOneWidget);
    });

    testWidgets('does not auto-start when autoStart is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              duration: Duration(seconds: 5),
              autoStart: false,
            ),
          ),
        ),
      );

      // Wait 1 second
      await tester.pump(const Duration(seconds: 1));

      // Should still show 5 seconds
      expect(find.text('5s'), findsOneWidget);
    });
  });
}
