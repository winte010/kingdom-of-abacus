/// Configuration for Pearl Keeper character animations and appearance
class CharacterConfig {
  // Animation Durations
  static const Duration idleDuration = Duration(milliseconds: 2000);
  static const Duration celebrateDuration = Duration(milliseconds: 1500);
  static const Duration encourageDuration = Duration(milliseconds: 1200);
  static const Duration thinkDuration = Duration(milliseconds: 1800);

  // Animation Physics
  static const double bounceHeight = 40.0; // pixels
  static const double spinRotations = 1.0; // full rotations
  static const double waveAmplitude = 15.0; // pixels
  static const double scratchAmplitude = 8.0; // pixels

  // Spring Physics Parameters (for bouncy feel)
  static const double springStiffness = 200.0;
  static const double springDamping = 15.0;

  // Character Size and Position
  static const double defaultSize = 120.0; // Base size in pixels
  static const double minSize = 80.0;
  static const double maxSize = 180.0;

  // Position on screen (relative to screen size)
  static const double defaultBottomOffset = 20.0; // From bottom edge
  static const double defaultRightOffset = 20.0; // From right edge

  // Alternative positions for different contexts
  static const double bossBottomOffset = 80.0; // Higher when boss is present
  static const double practiceLeftOffset = 20.0; // Left side for practice mode

  // Visual Style
  static const double strokeWidth = 2.5;
  static const double watercolorOpacity = 0.85;

  // Colors (watercolor palette)
  static const int primaryBrown = 0xFF8B6F47; // Otter fur
  static const int secondaryBrown = 0xFFA0826D; // Lighter fur
  static const int bellyWhite = 0xFFF5F1E8; // Belly color
  static const int noseBlack = 0xFF2C2C2C; // Nose and eyes
  static const int blushPink = 0xFFFFB6C1; // Cheek blush
  static const int celebrationGold = 0xFFFFD700; // Sparkles

  // Animation Triggers
  static const int celebrateOnCorrectAnswerDelay = 100; // ms delay before celebrating
  static const int encourageAfterWrongAnswers = 2; // Show encouragement after N wrong
  static const double thinkProbability = 0.3; // 30% chance to think with player

  // Performance
  static const int targetFps = 60;
  static const bool enableShadows = true;
  static const bool enableParticles = true; // For celebration sparkles
  static const int maxParticles = 12;

  // State Management
  static const Duration stateTransitionDuration = Duration(milliseconds: 300);
  static const Duration minimumIdleTime = Duration(milliseconds: 500);

  // Asset Paths (if using images instead of CustomPainter)
  static const String assetBasePath = 'assets/characters/pearl_keeper/';
  static const String idleAsset = '${assetBasePath}idle.png';
  static const String celebrateAsset = '${assetBasePath}celebrate.png';
  static const String encourageAsset = '${assetBasePath}encourage.png';
  static const String thinkAsset = '${assetBasePath}think.png';

  // Interaction
  static const bool allowTapInteraction = true;
  static const Duration tapResponseDuration = Duration(milliseconds: 800);
}

/// Animation states for Pearl Keeper character
enum PearlKeeperState {
  idle,        // Default state - gentle bobbing
  celebrate,   // Jump and spin - correct answer!
  encourage,   // Wave paws - keep trying!
  think,       // Scratch head - thinking with player
}

/// Configuration for specific animation sequences
class AnimationSequenceConfig {
  final PearlKeeperState state;
  final Duration duration;
  final bool loops;
  final List<AnimationKeyframe> keyframes;

  const AnimationSequenceConfig({
    required this.state,
    required this.duration,
    this.loops = false,
    required this.keyframes,
  });
}

/// Individual keyframe in an animation
class AnimationKeyframe {
  final double time; // 0.0 to 1.0 (percentage of animation duration)
  final double x; // X offset
  final double y; // Y offset
  final double rotation; // Rotation in radians
  final double scale; // Scale multiplier

  const AnimationKeyframe({
    required this.time,
    this.x = 0.0,
    this.y = 0.0,
    this.rotation = 0.0,
    this.scale = 1.0,
  });
}

/// Predefined animation sequences
class PearlKeeperAnimations {
  // Celebrate: Jump up, spin, land
  static const celebrate = AnimationSequenceConfig(
    state: PearlKeeperState.celebrate,
    duration: CharacterConfig.celebrateDuration,
    keyframes: [
      AnimationKeyframe(time: 0.0, y: 0, rotation: 0, scale: 1.0),
      AnimationKeyframe(time: 0.3, y: -40, rotation: 0.5, scale: 1.1),
      AnimationKeyframe(time: 0.6, y: -40, rotation: 3.14, scale: 1.15),
      AnimationKeyframe(time: 0.85, y: -10, rotation: 6.28, scale: 1.05),
      AnimationKeyframe(time: 1.0, y: 0, rotation: 6.28, scale: 1.0),
    ],
  );

  // Encourage: Wave paws side to side
  static const encourage = AnimationSequenceConfig(
    state: PearlKeeperState.encourage,
    duration: CharacterConfig.encourageDuration,
    keyframes: [
      AnimationKeyframe(time: 0.0, x: 0, rotation: 0),
      AnimationKeyframe(time: 0.25, x: 10, rotation: 0.1),
      AnimationKeyframe(time: 0.5, x: 0, rotation: 0),
      AnimationKeyframe(time: 0.75, x: -10, rotation: -0.1),
      AnimationKeyframe(time: 1.0, x: 0, rotation: 0),
    ],
  );

  // Think: Gentle head tilt and scratch
  static const think = AnimationSequenceConfig(
    state: PearlKeeperState.think,
    duration: CharacterConfig.thinkDuration,
    keyframes: [
      AnimationKeyframe(time: 0.0, rotation: 0),
      AnimationKeyframe(time: 0.3, rotation: 0.15),
      AnimationKeyframe(time: 0.7, rotation: 0.15),
      AnimationKeyframe(time: 1.0, rotation: 0),
    ],
  );

  // Idle: Gentle bobbing
  static const idle = AnimationSequenceConfig(
    state: PearlKeeperState.idle,
    duration: CharacterConfig.idleDuration,
    loops: true,
    keyframes: [
      AnimationKeyframe(time: 0.0, y: 0, scale: 1.0),
      AnimationKeyframe(time: 0.5, y: -5, scale: 1.02),
      AnimationKeyframe(time: 1.0, y: 0, scale: 1.0),
    ],
  );
}
