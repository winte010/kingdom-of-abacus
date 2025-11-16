import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_of_abacus/widgets/boss/boss_health_bar.dart';

void main() {
  group('BossHealthBar', () {
    testWidgets('displays "Boss Health" label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 50,
            ),
          ),
        ),
      );

      expect(find.text('Boss Health'), findsOneWidget);
    });

    testWidgets('displays current and max health', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 75,
              maxHealth: 100,
            ),
          ),
        ),
      );

      expect(find.text('75 / 100'), findsOneWidget);
    });

    testWidgets('shows progress bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 50,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('calculates correct health percentage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 60,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 0.6);
    });

    testWidgets('shows red color when health > 50%', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 80,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      final color = (progressBar.valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color, Colors.red);
    });

    testWidgets('shows orange color when health between 25% and 50%',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 40,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      final color = (progressBar.valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color, Colors.orange);
    });

    testWidgets('shows yellow color when health < 25%', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 20,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      final color = (progressBar.valueColor as AlwaysStoppedAnimation<Color>).value;
      expect(color, Colors.yellow);
    });

    testWidgets('handles zero health', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 0,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 0.0);
      expect(find.text('0 / 100'), findsOneWidget);
    });

    testWidgets('handles full health', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 100,
              maxHealth: 100,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 1.0);
    });

    testWidgets('has proper height for health bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BossHealthBar(
              currentHealth: 50,
            ),
          ),
        ),
      );

      final progressBar =
          tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(progressBar.minHeight, 24);
    });
  });
}
