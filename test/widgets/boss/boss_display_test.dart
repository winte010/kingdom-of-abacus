import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/boss/boss_display.dart';

void main() {
  group('BossDisplay', () {
    testWidgets('displays boss name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
            ),
          ),
        ),
      );

      expect(find.text('Chaos Kraken'), findsNWidgets(2)); // Name shown twice: in circle and below
    });

    testWidgets('shows circular container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Chaos Kraken').first,
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('has correct dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Chaos Kraken').first,
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxWidth, 200);
      expect(container.constraints?.maxHeight, 200);
    });

    testWidgets('displays boss name with headline style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
            ),
          ),
        ),
      );

      final nameText = tester.widget<Text>(find.text('Chaos Kraken').last);
      expect(nameText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('accepts state parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
              state: 'attacking',
            ),
          ),
        ),
      );

      // Widget should render without errors
      expect(find.text('Chaos Kraken'), findsNWidgets(2));
    });

    testWidgets('defaults to idle state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossDisplay(
              bossName: 'Chaos Kraken',
            ),
          ),
        ),
      );

      final widget = tester.widget<BossDisplay>(find.byType(BossDisplay));
      expect(widget.state, 'idle');
    });
  });
}
