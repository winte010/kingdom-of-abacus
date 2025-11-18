import 'dart:io';
import 'package:flutter/material.dart';
import 'interactive_math_object.dart';

/// Treasure chest widget for collection activities
/// Objects can be dragged into the chest to count them
class TreasureChest extends StatefulWidget {
  final int targetCount;
  final Function(int) onCountChange;
  final bool enabled;
  final InteractionStyle interactionStyle;

  const TreasureChest({
    super.key,
    required this.targetCount,
    required this.onCountChange,
    this.enabled = true,
    this.interactionStyle = InteractionStyle.drag,
  });

  @override
  State<TreasureChest> createState() => _TreasureChestState();
}

class _TreasureChestState extends State<TreasureChest>
    with SingleTickerProviderStateMixin {
  int _collectedCount = 0;
  final List<int> _availableItems = [];
  late AnimationController _chestController;

  @override
  void initState() {
    super.initState();
    _chestController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize available items (more than target for challenge)
    _availableItems.addAll(List.generate(widget.targetCount + 5, (i) => i));
  }

  @override
  void dispose() {
    _chestController.dispose();
    super.dispose();
  }

  void _handleItemCollected(int value) {
    if (!widget.enabled || _collectedCount >= widget.targetCount) return;

    setState(() {
      _collectedCount++;
      _availableItems.remove(value);
    });

    // Animate chest opening
    _chestController.forward().then((_) {
      _chestController.reverse();
    });

    widget.onCountChange(_collectedCount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Treasure chest (drop target)
        DragTarget<int>(
          onAcceptWithDetails: (details) => _handleItemCollected(details.data),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return AnimatedBuilder(
              animation: _chestController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_chestController.value * 0.1),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: isHovering
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isHovering
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: 3,
                      ),
                      boxShadow: isHovering
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    child: _ChestWidget(
                      collectedCount: _collectedCount,
                      targetCount: widget.targetCount,
                      isOpen: _chestController.value > 0.5,
                    ),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 24),

        // Count display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Collected: $_collectedCount / ${widget.targetCount}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Available items to collect
        if (_availableItems.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableItems.length,
              itemBuilder: (context, index) {
                final itemValue = _availableItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InteractiveMathObject(
                    value: itemValue,
                    enabled: widget.enabled,
                    interactionStyle: widget.interactionStyle,
                    size: 80,
                    onDragComplete: _handleItemCollected,
                    child: _TreasureWidget(enabled: widget.enabled),
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
              'Drag treasures into the chest!',
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

/// Chest widget with visual states
class _ChestWidget extends StatelessWidget {
  final int collectedCount;
  final int targetCount;
  final bool isOpen;

  const _ChestWidget({
    required this.collectedCount,
    required this.targetCount,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    const assetPath = 'assets/images/math_objects/chest.png';
    final assetExists = File(assetPath).existsSync();

    return Stack(
      children: [
        // Chest image or fallback
        Center(
          child: assetExists
              ? Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                )
              : Icon(
                  isOpen ? Icons.inventory_2 : Icons.inventory_2_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
        ),

        // Count badge
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$collectedCount',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual treasure item widget
class _TreasureWidget extends StatelessWidget {
  final bool enabled;

  const _TreasureWidget({required this.enabled});

  @override
  Widget build(BuildContext context) {
    const assetPath = 'assets/images/math_objects/treasure.png';
    final assetExists = File(assetPath).existsSync();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: 2,
        ),
      ),
      child: assetExists
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            )
          : Icon(
              Icons.diamond,
              size: 40,
              color: Theme.of(context).colorScheme.tertiary,
            ),
    );
  }
}
