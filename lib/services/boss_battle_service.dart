/// Manages boss battle state and mechanics
class BossBattleService {
  final int totalProblems;
  int _problemsCompleted = 0;
  int _consecutiveWrong = 0;
  Duration _currentTimeLimit;

  late int bossMaxHealth;
  late double _bossHealth;

  BossBattleService({
    required this.totalProblems,
    Duration? initialTimeLimit,
  }) : _currentTimeLimit = initialTimeLimit ?? const Duration(seconds: 10) {
    bossMaxHealth = 100;
    _bossHealth = 100.0;
  }

  /// Current boss health (0-100)
  double get bossHealth => _bossHealth;

  /// Boss is defeated
  bool get isDefeated => _bossHealth <= 0;

  /// Battle is won
  bool get isVictory => _problemsCompleted >= totalProblems || isDefeated;

  /// Current time limit per problem
  Duration get currentTimeLimit => _currentTimeLimit;

  /// Problems completed so far
  int get problemsCompleted => _problemsCompleted;

  /// Record a correct answer
  void recordCorrectAnswer() {
    _problemsCompleted++;
    _consecutiveWrong = 0;

    // Damage boss
    final damage = 100.0 / totalProblems;
    _bossHealth = (_bossHealth - damage).clamp(0.0, 100.0);
  }

  /// Record a wrong answer
  void recordWrongAnswer() {
    _consecutiveWrong++;

    // Adaptive timer: add time if struggling
    if (_consecutiveWrong == 2) {
      _currentTimeLimit += const Duration(seconds: 5);
    } else if (_consecutiveWrong == 4) {
      _currentTimeLimit += const Duration(seconds: 10);
    }
  }

  /// Reset for new battle
  void reset() {
    _problemsCompleted = 0;
    _consecutiveWrong = 0;
    _bossHealth = 100.0;
    _currentTimeLimit = const Duration(seconds: 10);
  }
}
