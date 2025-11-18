import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../models/segment.dart';

/// Controller for managing Rive character animations
/// Handles emotion state changes and animation blending
class CharacterController {
  RiveAnimationController? _currentController;
  StateMachineController? _stateMachineController;
  CharacterEmotion _currentEmotion = CharacterEmotion.happy;

  CharacterEmotion get currentEmotion => _currentEmotion;

  /// Initialize the character controller with a Rive artboard
  /// Returns true if initialization was successful
  bool initialize(Artboard artboard, {String stateMachineName = 'State Machine 1'}) {
    try {
      // Try to get state machine controller
      final controller = StateMachineController.fromArtboard(
        artboard,
        stateMachineName,
      );

      if (controller != null) {
        artboard.addController(controller);
        _stateMachineController = controller;
        _currentController = controller;
        return true;
      }

      // Fallback: use simple animation controller if state machine not found
      debugPrint('State machine "$stateMachineName" not found, using simple animation');
      final simpleController = SimpleAnimation('idle');
      artboard.addController(simpleController);
      _currentController = simpleController;
      return true;
    } catch (e) {
      debugPrint('Error initializing character controller: $e');
      return false;
    }
  }

  /// Change the character's emotion state
  /// If using a state machine, this will trigger the appropriate state
  void setEmotion(CharacterEmotion emotion) {
    if (_currentEmotion == emotion) return;

    _currentEmotion = emotion;

    // If we have a state machine, try to trigger the emotion state
    if (_stateMachineController != null) {
      _triggerEmotionInStateMachine(emotion);
    }
  }

  /// Trigger emotion state in the Rive state machine
  void _triggerEmotionInStateMachine(CharacterEmotion emotion) {
    try {
      // Try to find and trigger the emotion as a trigger
      final triggerName = _emotionToTriggerName(emotion);
      final trigger = _stateMachineController?.findInput<bool>(triggerName);

      if (trigger != null) {
        trigger.value = true;
        debugPrint('Triggered emotion: $triggerName');
        return;
      }

      // Try to find and set the emotion as a number input
      final emotionInput = _stateMachineController?.findInput<double>('emotion');
      if (emotionInput != null) {
        emotionInput.value = _emotionToNumber(emotion);
        debugPrint('Set emotion number: ${_emotionToNumber(emotion)}');
        return;
      }

      debugPrint('Could not find trigger or input for emotion: $emotion');
    } catch (e) {
      debugPrint('Error triggering emotion: $e');
    }
  }

  /// Convert emotion enum to trigger name for Rive state machine
  String _emotionToTriggerName(CharacterEmotion emotion) {
    switch (emotion) {
      case CharacterEmotion.happy:
        return 'happy';
      case CharacterEmotion.excited:
        return 'excited';
      case CharacterEmotion.worried:
        return 'worried';
      case CharacterEmotion.proud:
        return 'proud';
      case CharacterEmotion.surprised:
        return 'surprised';
    }
  }

  /// Convert emotion enum to number for state machine number inputs
  double _emotionToNumber(CharacterEmotion emotion) {
    switch (emotion) {
      case CharacterEmotion.happy:
        return 0.0;
      case CharacterEmotion.excited:
        return 1.0;
      case CharacterEmotion.worried:
        return 2.0;
      case CharacterEmotion.proud:
        return 3.0;
      case CharacterEmotion.surprised:
        return 4.0;
    }
  }

  /// Play a one-shot animation (if supported by the Rive file)
  void playAnimation(String animationName) {
    if (_stateMachineController != null) {
      try {
        final trigger = _stateMachineController?.findInput<bool>(animationName);
        if (trigger != null) {
          trigger.value = true;
        }
      } catch (e) {
        debugPrint('Error playing animation $animationName: $e');
      }
    }
  }

  /// Dispose of the controller and clean up resources
  void dispose() {
    _currentController?.dispose();
    _currentController = null;
    _stateMachineController = null;
  }

  /// Get all available inputs from the state machine (useful for debugging)
  List<String> getAvailableInputs() {
    if (_stateMachineController == null) return [];

    final inputs = <String>[];
    for (var input in _stateMachineController!.inputs) {
      inputs.add('${input.name} (${input.runtimeType})');
    }
    return inputs;
  }

  /// Get all available animations from the artboard (useful for debugging)
  static List<String> getAvailableAnimations(Artboard artboard) {
    return artboard.animations.map((anim) => anim.name).toList();
  }

  /// Get all available state machines from the artboard (useful for debugging)
  static List<String> getAvailableStateMachines(Artboard artboard) {
    return artboard.stateMachines.map((sm) => sm.name).toList();
  }
}
