/// Configuration for Pearl Keeper character animations and appearance
class CharacterConfig {
  // Animation Durations
  static const Duration idleDuration = Duration(seconds: 2);
  static const Duration celebrateDuration = Duration(milliseconds: 1200);
  static const Duration encourageDuration = Duration(milliseconds: 1500);
  static const Duration thinkDuration = Duration(milliseconds: 1800);

  // Animation Physics
  static const double springTension = 200.0;
  static const double springFriction = 10.0;
  static const double bounciness = 0.8;

  // Character Size and Position
  static const double defaultSize = 120.0;
  static const double minSize = 80.0;
  static const double maxSize = 200.0;

  // Position Settings (percentage of screen)
  static const double defaultBottomOffset = 0.1; // 10% from bottom
  static const double defaultRightOffset = 0.05; // 5% from right

  // Celebration Triggers
  static const int celebrateOnCorrectStreak = 3;
  static const bool celebrateOnFirstCorrect = true;
  static const bool encourageOnIncorrect = true;
  static const bool thinkDuringProblem = true;

  // Visual Settings
  static const double strokeWidth = 2.5;
  static const double watercolorOpacity = 0.85;

  // Colors - Hand-drawn watercolor palette
  static const int primaryColor = 0xFF8B6F47; // Warm brown for otter
  static const int secondaryColor = 0xFFD4A574; // Light tan
  static const int accentColor = 0xFFFFE4B5; // Cream/beige
  static const int highlightColor = 0xFFFFFFFF; // White highlights
  static const int shadowColor = 0xFF5D4E37; // Dark brown shadow
  static const int pearlColor = 0xFFF0EAD6; // Pearl white
  static const int waterColor = 0xFF87CEEB; // Sky blue for water effects

  // Animation Curves
  static const String celebrateCurve = 'elasticOut';
  static const String encourageCurve = 'easeInOut';
  static const String thinkCurve = 'easeInOutBack';

  // Asset Paths (if using images instead of CustomPainter)
  static const String assetBasePath = 'assets/characters/pearl_keeper/';
  static const String idleAsset = '${assetBasePath}idle.png';
  static const String celebrateAsset = '${assetBasePath}celebrate.png';
  static const String encourageAsset = '${assetBasePath}encourage.png';
  static const String thinkAsset = '${assetBasePath}think.png';

  // Performance Settings
  static const int targetFrameRate = 60;
  static const bool enablePerformanceMonitoring = false;
  static const bool cacheAnimations = true;

  // Interaction Settings
  static const bool blockUserInteraction = false;
  static const bool respondToTaps = true;
  static const double tapResponseRadius = 60.0;
}

/// Animation state for Pearl Keeper character
enum PearlKeeperState {
  idle,
  celebrate,
  encourage,
  think,
  enter,
  exit,
}

/// Configuration for specific animation sequences
class AnimationSequenceConfig {
  final PearlKeeperState state;
  final Duration duration;
  final String curve;
  final bool loop;

  const AnimationSequenceConfig({
    required this.state,
    required this.duration,
    required this.curve,
    this.loop = false,
  });

  static const celebrate = AnimationSequenceConfig(
    state: PearlKeeperState.celebrate,
    duration: CharacterConfig.celebrateDuration,
    curve: CharacterConfig.celebrateCurve,
    loop: false,
  );

  static const encourage = AnimationSequenceConfig(
    state: PearlKeeperState.encourage,
    duration: CharacterConfig.encourageDuration,
    curve: CharacterConfig.encourageCurve,
    loop: false,
  );

  static const think = AnimationSequenceConfig(
    state: PearlKeeperState.think,
    duration: CharacterConfig.thinkDuration,
    curve: CharacterConfig.thinkCurve,
    loop: false,
  );

  static const idle = AnimationSequenceConfig(
    state: PearlKeeperState.idle,
    duration: CharacterConfig.idleDuration,
    curve: 'easeInOut',
    loop: true,
  );
}
