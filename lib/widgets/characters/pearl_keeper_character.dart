import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../../models/segment.dart';
import '../../animations/character_controller.dart';

/// Widget displaying the Pearl Keeper character with Rive animations
/// Supports configurable emotion states and graceful fallback when .riv files are missing
class PearlKeeperCharacter extends StatefulWidget {
  /// Path to the .riv animation file
  /// Defaults to 'assets/characters/pearl_keeper/pearl_keeper.riv'
  final String? animationPath;

  /// Initial emotion state for the character
  final CharacterEmotion emotion;

  /// Width of the character widget
  final double width;

  /// Height of the character widget
  final double height;

  /// Name of the state machine in the Rive file
  /// Defaults to 'State Machine 1'
  final String stateMachineName;

  /// Whether to show debug information
  final bool showDebugInfo;

  const PearlKeeperCharacter({
    super.key,
    this.animationPath,
    this.emotion = CharacterEmotion.happy,
    this.width = 200,
    this.height = 200,
    this.stateMachineName = 'State Machine 1',
    this.showDebugInfo = false,
  });

  @override
  State<PearlKeeperCharacter> createState() => _PearlKeeperCharacterState();
}

class _PearlKeeperCharacterState extends State<PearlKeeperCharacter> {
  Artboard? _artboard;
  CharacterController? _characterController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  void didUpdateWidget(PearlKeeperCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update emotion if it changed
    if (oldWidget.emotion != widget.emotion && _characterController != null) {
      _characterController!.setEmotion(widget.emotion);
    }

    // Reload if animation path changed
    if (oldWidget.animationPath != widget.animationPath) {
      _loadRiveFile();
    }
  }

  Future<void> _loadRiveFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final path = widget.animationPath ??
                   'assets/characters/pearl_keeper/pearl_keeper.riv';

      // Try to load the Rive file
      final data = await rootBundle.load(path);
      final file = RiveFile.import(data);

      // Get the main artboard
      final artboard = file.mainArtboard;

      // Initialize character controller
      final controller = CharacterController();
      final success = controller.initialize(
        artboard,
        stateMachineName: widget.stateMachineName,
      );

      if (success) {
        // Set initial emotion
        controller.setEmotion(widget.emotion);

        if (widget.showDebugInfo) {
          debugPrint('Available animations: ${CharacterController.getAvailableAnimations(artboard)}');
          debugPrint('Available state machines: ${CharacterController.getAvailableStateMachines(artboard)}');
          debugPrint('Available inputs: ${controller.getAvailableInputs()}');
        }

        setState(() {
          _artboard = artboard;
          _characterController = controller;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to initialize animation controller';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading Rive file: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _characterController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null || _artboard == null) {
      return _buildErrorState();
    }

    return _buildAnimation();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    // Graceful fallback: show a placeholder character
    return _buildPlaceholder();
  }

  Widget _buildAnimation() {
    return Rive(
      artboard: _artboard!,
      fit: BoxFit.contain,
    );
  }

  /// Placeholder widget shown when .riv file is missing or fails to load
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmotionIcon(),
            size: widget.width * 0.4,
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 8),
          Text(
            'Pearl Keeper',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          if (widget.showDebugInfo && _errorMessage != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Debug: ${_errorMessage!.substring(0, _errorMessage!.length > 50 ? 50 : _errorMessage!.length)}...',
                style: const TextStyle(fontSize: 10, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Get icon based on current emotion for placeholder
  IconData _getEmotionIcon() {
    switch (widget.emotion) {
      case CharacterEmotion.happy:
        return Icons.sentiment_satisfied;
      case CharacterEmotion.excited:
        return Icons.sentiment_very_satisfied;
      case CharacterEmotion.worried:
        return Icons.sentiment_dissatisfied;
      case CharacterEmotion.proud:
        return Icons.emoji_events;
      case CharacterEmotion.surprised:
        return Icons.sentiment_neutral;
    }
  }

  /// Public method to change emotion (can be called from parent widgets)
  void setEmotion(CharacterEmotion emotion) {
    _characterController?.setEmotion(emotion);
  }

  /// Public method to play a specific animation
  void playAnimation(String animationName) {
    _characterController?.playAnimation(animationName);
  }
}
