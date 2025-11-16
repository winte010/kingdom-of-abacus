import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Number pad for kids to input answers
class NumberPad extends StatefulWidget {
  final Function(int) onSubmit;
  final VoidCallback? onDelete;
  final bool enabled;

  const NumberPad({
    super.key,
    required this.onSubmit,
    this.onDelete,
    this.enabled = true,
  });

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String _currentInput = '';

  void _onNumberTap(int number) {
    if (!widget.enabled) return;

    setState(() {
      _currentInput += number.toString();
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _onDelete() {
    if (!widget.enabled || _currentInput.isEmpty) return;

    setState(() {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    });

    HapticFeedback.mediumImpact();
    widget.onDelete?.call();
  }

  void _onSubmit() {
    if (!widget.enabled || _currentInput.isEmpty) return;

    final answer = int.tryParse(_currentInput);
    if (answer != null) {
      HapticFeedback.heavyImpact();
      widget.onSubmit(answer);
      setState(() {
        _currentInput = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display current input
          Container(
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _currentInput.isEmpty ? '?' : _currentInput,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Number buttons (1-9)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final number = index + 1;
              return _NumberButton(
                number: number,
                onTap: () => _onNumberTap(number),
                enabled: widget.enabled,
              );
            },
          ),

          const SizedBox(height: 8),

          // Bottom row: Delete, 0, Submit
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.backspace_outlined,
                  label: 'Delete',
                  onTap: _onDelete,
                  enabled: widget.enabled && _currentInput.isNotEmpty,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumberButton(
                  number: 0,
                  onTap: () => _onNumberTap(0),
                  enabled: widget.enabled,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.check,
                  label: 'Submit',
                  onTap: _onSubmit,
                  enabled: widget.enabled && _currentInput.isNotEmpty,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onTap;
  final bool enabled;

  const _NumberButton({
    required this.number,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: enabled
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              semanticsLabel: number.toString(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.enabled,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondaryContainer;

    final foregroundColor = isPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondaryContainer;

    return Material(
      color: enabled
          ? backgroundColor
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          child: Center(
            child: Icon(
              icon,
              size: 32,
              color: enabled
                  ? foregroundColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              semanticLabel: label,
            ),
          ),
        ),
      ),
    );
  }
}
