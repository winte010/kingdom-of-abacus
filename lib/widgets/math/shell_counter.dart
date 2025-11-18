import 'dart:io';
import 'package:flutter/material.dart';
import 'interactive_math_object.dart';

/// Shell counter widget for addition and grouping activities
/// Displays shells that can be tapped or dragged to count
class ShellCounter extends StatefulWidget {
  final int maxShells;
  final Function(int) onCountChange;
  final bool enabled;
  final InteractionStyle interactionStyle;

  const ShellCounter({
    super.key,
    required this.maxShells,
    required this.onCountChange,
    this.enabled = true,
    this.interactionStyle = InteractionStyle.tap,
  });

  @override
  State<ShellCounter> createState() => _ShellCounterState();
}

class _ShellCounterState extends State<ShellCounter> {
  final Set<int> _selectedShells = {};

  void _handleShellTap(int index) {
    if (!widget.enabled) return;

    setState(() {
      if (_selectedShells.contains(index)) {
        _selectedShells.remove(index);
      } else {
        _selectedShells.add(index);
      }
    });

    widget.onCountChange(_selectedShells.length);
  }

  void _handleShellDrag(int index) {
    if (!widget.enabled) return;

    setState(() {
      _selectedShells.add(index);
    });

    widget.onCountChange(_selectedShells.length);
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
            'Count: ${_selectedShells.length}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Shell grid
        Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: widget.maxShells,
            itemBuilder: (context, index) {
              final isSelected = _selectedShells.contains(index);
              return InteractiveMathObject(
                value: index,
                enabled: widget.enabled,
                interactionStyle: widget.interactionStyle,
                onTap: (_) => _handleShellTap(index),
                onDragComplete: (_) => _handleShellDrag(index),
                child: _ShellWidget(
                  isSelected: isSelected,
                  enabled: widget.enabled,
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
                  ? 'Tap shells to count them'
                  : widget.interactionStyle == InteractionStyle.drag
                      ? 'Drag shells to group them'
                      : 'Tap or drag shells to count',
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

/// Individual shell widget with visual states
class _ShellWidget extends StatelessWidget {
  final bool isSelected;
  final bool enabled;

  const _ShellWidget({
    required this.isSelected,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    const assetPath = 'assets/images/math_objects/shell.png';
    final assetExists = File(assetPath).existsSync();

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
      child: assetExists
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                color: isSelected ? null : Colors.grey,
                colorBlendMode: isSelected ? null : BlendMode.saturation,
              ),
            )
          : Icon(
              Icons.water_drop,
              size: 40,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
    );
  }
}
