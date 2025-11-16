class AppConstants {
  // App Info
  static const String appName = 'Kingdom of Abacus';
  static const String version = '1.0.0';

  // Timing
  static const int defaultTimeLimitSeconds = 10;
  static const int bossBattleTimeLimitSeconds = 12;

  // Adaptive Difficulty
  static const double sideQuestTriggerThreshold = 0.7;
  static const int sideQuestMinAttempts = 3;
  static const double sideQuestPassThreshold = 0.8;
  static const int sideQuestProblemCount = 10;

  // Boss Battle
  static const int bossMaxHealth = 100;
  static const int bossTotalProblems = 30;

  // Problem Generation
  static const int maxGenerationAttempts = 100;

  // Sync
  static const Duration syncRetryDelay = Duration(seconds: 30);
  static const int maxSyncRetries = 3;
}
