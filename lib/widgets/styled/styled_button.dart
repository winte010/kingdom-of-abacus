import 'package:flutter/material.dart';
import '../../config/design_tokens.dart';

/// Styled button with hand-drawn border and pastel colors
/// Maintains separation between presentation and business logic
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final StyledButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const StyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = StyledButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return _buildLoadingButton(theme);
    }

    return Container(
      decoration: _getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceLg,
              vertical: DesignTokens.spaceMd,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: DesignTokens.iconSizeSm,
                    color: _getTextColor(theme),
                  ),
                  SizedBox(width: DesignTokens.spaceSm),
                ],
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingButton(ThemeData theme) {
    return Container(
      decoration: _getDecoration().copyWith(
        color: _getBackgroundColor(theme).withOpacity(DesignTokens.opacityDisabled),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceLg,
        vertical: DesignTokens.spaceMd,
      ),
      child: SizedBox(
        height: DesignTokens.iconSizeSm,
        width: DesignTokens.iconSizeSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(_getTextColor(theme)),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    return BoxDecoration(
      color: variant == StyledButtonVariant.outlined
          ? Colors.transparent
          : null,
      gradient: variant != StyledButtonVariant.outlined
          ? _getGradient()
          : null,
      borderRadius: DesignTokens.irregularBorderRadius,
      border: variant == StyledButtonVariant.outlined
          ? Border.all(
              color: _getBorderColor(),
              width: 2,
            )
          : null,
      boxShadow: variant != StyledButtonVariant.outlined
          ? DesignTokens.shadowSoft
          : null,
    );
  }

  LinearGradient? _getGradient() {
    switch (variant) {
      case StyledButtonVariant.primary:
        return LinearGradient(
          colors: [
            DesignTokens.primaryLavender,
            DesignTokens.primaryLavender.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StyledButtonVariant.secondary:
        return LinearGradient(
          colors: [
            DesignTokens.secondaryMint,
            DesignTokens.secondaryMint.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StyledButtonVariant.accent:
        return LinearGradient(
          colors: [
            DesignTokens.accentPeach,
            DesignTokens.accentPeach.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case StyledButtonVariant.outlined:
        return null;
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (variant) {
      case StyledButtonVariant.primary:
        return theme.colorScheme.primary;
      case StyledButtonVariant.secondary:
        return theme.colorScheme.secondary;
      case StyledButtonVariant.accent:
        return theme.colorScheme.tertiary;
      case StyledButtonVariant.outlined:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
    if (variant == StyledButtonVariant.outlined) {
      return theme.colorScheme.primary;
    }
    return DesignTokens.textCharcoal;
  }

  Color _getBorderColor() {
    switch (variant) {
      case StyledButtonVariant.primary:
        return DesignTokens.primaryLavender;
      case StyledButtonVariant.secondary:
        return DesignTokens.secondaryMint;
      case StyledButtonVariant.accent:
        return DesignTokens.accentPeach;
      case StyledButtonVariant.outlined:
        return DesignTokens.primaryLavender;
    }
  }
}

/// Button style variants
enum StyledButtonVariant {
  primary,
  secondary,
  accent,
  outlined,
}
