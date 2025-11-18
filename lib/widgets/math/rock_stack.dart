import 'dart:io';
import 'package:flutter/material.dart';
import 'interactive_math_object.dart';

/// Rock stack widget for counting and stacking activities
/// Rocks can be stacked vertically to visualize counting
class RockStack extends StatefulWidget {
  final int maxRocks;
  final Function(int) onCountChange;
  final bool enabled;
  final InteractionStyle interactionStyle;

  const RockStack({
    super.key,
    required this.maxRocks,
    required this.onCountChange,
    this.enabled = true,
    this.interactionStyle = InteractionStyle.both,
  });

  @override
  State<RockStack> createState() => _RockStackState();
}

class _RockStackState extends State<RockStack>
    with SingleTickerProviderStateMixin {
  final List<int> _stackedRocks = [];
  final List<int> _availableRocks = [];
  late AnimationController _stackController;

  @override
  void initState() {
    super.initState();
    _stackController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Initialize available rocks
    _availableRocks.addAll(List.generate(widget.maxRocks, (i) => i));
  }

  @override
  void dispose() {
    _stackController.dispose();
    super.dispose();
  }

  void _handleRockAdd(int value) {
    if (!widget.enabled || _stackedRocks.length >= widget.maxRocks) return;

    setState(() {
      _stackedRocks.add(value);
      _availableRocks.remove(value);
    });

    // Animate stack
    _stackController.forward().then((_) {
      _stackController.reverse();
    });

    widget.onCountChange(_stackedRocks.length);
  }

  void _handleRockRemove() {
    if (!widget.enabled || _stackedRocks.isEmpty) return;

    setState(() {
      final removed = _stackedRocks.removeLast();
      _availableRocks.add(removed);
    });

    widget.onCountChange(_stackedRocks.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Count display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Stacked: ${_stackedRocks.length}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Stack area (drop target)
        DragTarget<int>(
          onAcceptWithDetails: (details) => _handleRockAdd(details.data),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 300),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovering
                    ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovering
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: _stackedRocks.isEmpty
                  ? Center(
                      child: Text(
                        'Drop rocks here to stack',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ..._stackedRocks.reversed.map((rockId) {
                          final index = _stackedRocks.indexOf(rockId);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: AnimatedBuilder(
                              animation: _stackController,
                              builder: (context, child) {
                                final isLatest = index == _stackedRocks.length - 1;
                                final scale = isLatest
                                    ? 1.0 + (_stackController.value * 0.1)
                                    : 1.0;
                                return Transform.scale(
                                  scale: scale,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (index == _stackedRocks.length - 1) {
                                        _handleRockRemove();
                                      }
                                    },
                                    child: _RockWidget(
                                      size: 60,
                                      enabled: widget.enabled,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Available rocks
        if (_availableRocks.isNotEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableRocks.length,
              itemBuilder: (context, index) {
                final rockValue = _availableRocks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InteractiveMathObject(
                    value: rockValue,
                    enabled: widget.enabled,
                    interactionStyle: widget.interactionStyle,
                    size: 70,
                    onTap: _handleRockAdd,
                    onDragComplete: _handleRockAdd,
                    child: _RockWidget(
                      size: 70,
                      enabled: widget.enabled,
                    ),
                  ),
                );
              },
            ),
          ),

        // Instructions
        if (widget.enabled)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.interactionStyle == InteractionStyle.tap
                  ? 'Tap rocks to stack them'
                  : widget.interactionStyle == InteractionStyle.drag
                      ? 'Drag rocks to stack them'
                      : 'Tap or drag rocks to stack',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

/// Individual rock widget
class _RockWidget extends StatelessWidget {
  final double size;
  final bool enabled;

  const _RockWidget({
    required this.size,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    const assetPath = 'assets/images/math_objects/rock.png';
    final assetExists = File(assetPath).existsSync();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHigh,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: assetExists
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.3),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            )
          : Icon(
              Icons.circle,
              size: size * 0.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
    );
  }
}
