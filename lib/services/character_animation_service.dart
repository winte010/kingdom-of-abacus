import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../config/character_config.dart';

/// Service to manage Pearl Keeper character animations and state
///
/// This service acts as the coordinator between game logic and character
/// animations, ensuring animations are triggered appropriately without
/// coupling game logic to presentation.
class CharacterAnimationService extends ChangeNotifier {
  PearlKeeperState _currentState = PearlKeeperState.idle;
  int _consecutiveWrongAnswers = 0;
  Timer? _stateTimer;
  DateTime? _lastStateChange;
  bool _isAnimating = false;

  // Configuration
  final bool _enableThinkingAnimation;
  final math.Random _random = math.Random();

  CharacterAnimationService({
    bool enableThinkingAnimation = true,
  }) : _enableThinkingAnimation = enableThinkingAnimation;

  /// Current animation state of the character
  PearlKeeperState get currentState => _currentState;

  /// Whether the character is currently playing a non-idle animation
  bool get isAnimating => _isAnimating;

  /// Trigger celebration animation for correct answer
  ///
  /// Displays an enthusiastic celebration animation with sparkles.
  /// Automatically returns to idle state after animation completes.
  void celebrateCorrect() {
    _scheduleStateChange(
      PearlKeeperState.celebrate,
      CharacterConfig.celebrateDuration,
    );
    _consecutiveWrongAnswers = 0; // Reset wrong answer counter
  }

  /// Trigger encouragement animation after wrong answers
  ///
  /// Shows supportive wave animation to encourage the player.
  /// Typically triggered after multiple consecutive wrong answers.
  void encouragePlayer() {
    _scheduleStateChange(
      PearlKeeperState.encourage,
      CharacterConfig.encourageDuration,
    );
  }

  /// Trigger thinking animation when player is considering answer
  ///
  /// Shows character thinking along with the player.
  /// Has a probability check to make it feel natural, not every time.
  void thinkWithPlayer() {
    if (!_enableThinkingAnimation) return;

    // Only occasionally show thinking animation
    if (_random.nextDouble() < CharacterConfig.thinkProbability) {
      _scheduleStateChange(
        PearlKeeperState.think,
        CharacterConfig.thinkDuration,
      );
    }
  }

  /// Handle incorrect answer submission
  ///
  /// Tracks consecutive wrong answers and triggers encouragement
  /// if the player is struggling.
  void onIncorrectAnswer() {
    _consecutiveWrongAnswers++;

    // Show encouragement after threshold
    if (_consecutiveWrongAnswers >= CharacterConfig.encourageAfterWrongAnswers) {
      encouragePlayer();
      _consecutiveWrongAnswers = 0; // Reset after encouraging
    }
  }

  /// Handle correct answer submission
  ///
  /// Triggers celebration animation with a small delay to sync
  /// with other visual feedback.
  Future<void> onCorrectAnswer() async {
    // Small delay to sync with other feedback animations
    await Future.delayed(
      Duration(milliseconds: CharacterConfig.celebrateOnCorrectAnswerDelay),
    );
    celebrateCorrect();
  }

  /// Reset character to idle state immediately
  void resetToIdle() {
    _cancelScheduledChange();
    _setState(PearlKeeperState.idle);
  }

  /// Handle new problem presentation
  ///
  /// Occasionally triggers thinking animation when a new problem appears.
  void onNewProblem() {
    if (_currentState == PearlKeeperState.idle) {
      thinkWithPlayer();
    }
  }

  /// Handle session start
  ///
  /// Resets all state and shows idle animation.
  void onSessionStart() {
    _consecutiveWrongAnswers = 0;
    resetToIdle();
  }

  /// Handle session end
  ///
  /// Cleans up timers and resets state.
  void onSessionEnd() {
    _consecutiveWrongAnswers = 0;
    _cancelScheduledChange();
    resetToIdle();
  }

  /// Schedule a state change with automatic return to idle
  void _scheduleStateChange(PearlKeeperState newState, Duration duration) {
    // Cancel any pending state change
    _cancelScheduledChange();

    // Respect minimum idle time
    if (_lastStateChange != null) {
      final timeSinceLastChange = DateTime.now().difference(_lastStateChange!);
      if (timeSinceLastChange < CharacterConfig.minimumIdleTime) {
        // Too soon, skip this animation
        return;
      }
    }

    _setState(newState);
    _isAnimating = true;

    // Schedule return to idle
    _stateTimer = Timer(duration, () {
      _setState(PearlKeeperState.idle);
      _isAnimating = false;
      _stateTimer = null;
    });
  }

  /// Cancel any scheduled state changes
  void _cancelScheduledChange() {
    _stateTimer?.cancel();
    _stateTimer = null;
    _isAnimating = false;
  }

  /// Internal state setter with notification
  void _setState(PearlKeeperState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _lastStateChange = DateTime.now();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelScheduledChange();
    super.dispose();
  }
}

/// Provider wrapper for CharacterAnimationService using Riverpod pattern
///
/// This can be used with Provider or Riverpod in the widget tree.
class CharacterAnimationProvider {
  static final CharacterAnimationService _instance = CharacterAnimationService();

  static CharacterAnimationService get instance => _instance;
}
