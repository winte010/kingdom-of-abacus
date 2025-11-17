import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/character_config.dart';

/// Service to manage Pearl Keeper character animations and state
/// Decoupled from game logic - responds to events rather than controlling game flow
class CharacterAnimationService extends ChangeNotifier {
  PearlKeeperState _currentState = PearlKeeperState.idle;
  int _correctStreak = 0;
  bool _isVisible = false;
  Timer? _stateTimer;
  final List<PearlKeeperState> _animationQueue = [];
  bool _isProcessingQueue = false;

  PearlKeeperState get currentState => _currentState;
  bool get isVisible => _isVisible;
  int get correctStreak => _correctStreak;

  /// Show the Pearl Keeper character
  void show() {
    if (!_isVisible) {
      _isVisible = true;
      _currentState = PearlKeeperState.idle;
      notifyListeners();
    }
  }

  /// Hide the Pearl Keeper character
  void hide() {
    if (_isVisible) {
      _isVisible = false;
      _correctStreak = 0;
      _cancelStateTimer();
      _animationQueue.clear();
      notifyListeners();
    }
  }

  /// Trigger celebration animation for correct answer
  Future<void> celebrateCorrect({bool immediate = false}) async {
    if (!_isVisible) return;

    _correctStreak++;

    // Determine if we should celebrate based on streak
    final shouldCelebrate = CharacterConfig.celebrateOnFirstCorrect ||
        _correctStreak % CharacterConfig.celebrateOnCorrectStreak == 0;

    if (shouldCelebrate || immediate) {
      await _queueAnimation(PearlKeeperState.celebrate);
    }
  }

  /// Trigger encouragement animation for incorrect answer
  Future<void> encouragePlayer({bool immediate = false}) async {
    if (!_isVisible) return;
    if (!CharacterConfig.encourageOnIncorrect && !immediate) return;

    // Reset streak on incorrect answer
    _correctStreak = 0;

    await _queueAnimation(PearlKeeperState.encourage);
  }

  /// Trigger thinking animation when problem is displayed
  Future<void> thinkWithPlayer({bool immediate = false}) async {
    if (!_isVisible) return;
    if (!CharacterConfig.thinkDuringProblem && !immediate) return;

    await _queueAnimation(PearlKeeperState.think);
  }

  /// Return to idle state
  void returnToIdle() {
    if (!_isVisible) return;

    _cancelStateTimer();
    _setState(PearlKeeperState.idle);
  }

  /// Queue an animation to play after current one completes
  Future<void> _queueAnimation(PearlKeeperState state) async {
    _animationQueue.add(state);
    if (!_isProcessingQueue) {
      await _processAnimationQueue();
    }
  }

  /// Process queued animations one by one
  Future<void> _processAnimationQueue() async {
    if (_animationQueue.isEmpty) {
      _isProcessingQueue = false;
      return;
    }

    _isProcessingQueue = true;

    while (_animationQueue.isNotEmpty) {
      final nextState = _animationQueue.removeAt(0);
      _setState(nextState);

      // Wait for animation to complete
      final duration = _getStateDuration(nextState);
      await Future.delayed(duration);
    }

    // Return to idle after all animations complete
    _setState(PearlKeeperState.idle);
    _isProcessingQueue = false;
  }

  /// Set the current animation state
  void _setState(PearlKeeperState state) {
    if (_currentState == state) return;

    _cancelStateTimer();
    _currentState = state;
    notifyListeners();

    // Auto-return to idle after animation duration (except for idle itself)
    if (state != PearlKeeperState.idle) {
      final duration = _getStateDuration(state);
      _stateTimer = Timer(duration, () {
        if (_currentState == state) {
          returnToIdle();
        }
      });
    }
  }

  /// Get duration for a specific state
  Duration _getStateDuration(PearlKeeperState state) {
    switch (state) {
      case PearlKeeperState.celebrate:
        return CharacterConfig.celebrateDuration;
      case PearlKeeperState.encourage:
        return CharacterConfig.encourageDuration;
      case PearlKeeperState.think:
        return CharacterConfig.thinkDuration;
      case PearlKeeperState.idle:
      default:
        return CharacterConfig.idleDuration;
    }
  }

  /// Cancel any pending state timer
  void _cancelStateTimer() {
    _stateTimer?.cancel();
    _stateTimer = null;
  }

  /// Reset the service state
  void reset() {
    _correctStreak = 0;
    _cancelStateTimer();
    _animationQueue.clear();
    _isProcessingQueue = false;
    if (_isVisible) {
      _currentState = PearlKeeperState.idle;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelStateTimer();
    _animationQueue.clear();
    super.dispose();
  }
}

/// Factory for creating CharacterAnimationService instances
class CharacterAnimationServiceFactory {
  static CharacterAnimationService create() {
    return CharacterAnimationService();
  }
}
