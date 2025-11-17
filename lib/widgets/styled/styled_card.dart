import 'package:flutter/material.dart';
import '../../config/design_tokens.dart';

/// Styled card with watercolor shadow effect
/// Maintains separation between presentation and business logic
class StyledCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final StyledCardVariant variant;
  final Color? backgroundColor;

  const StyledCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.variant = StyledCardVariant.elevated,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? EdgeInsets.all(DesignTokens.spaceMd),
      decoration: _getDecoration(theme),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: Padding(
            padding: padding ?? EdgeInsets.all(DesignTokens.spaceMd),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(ThemeData theme) {
    switch (variant) {
      case StyledCardVariant.elevated:
        return BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          boxShadow: DesignTokens.shadowSoft,
        );

      case StyledCardVariant.outlined:
        return BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 2,
          ),
        );

      case StyledCardVariant.watercolor:
        return BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: DesignTokens.irregularBorderRadius,
          boxShadow: DesignTokens.shadowMedium,
        );

      case StyledCardVariant.gradient:
        return BoxDecoration(
          gradient: _getPastelGradient(),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          boxShadow: DesignTokens.shadowSoft,
        );
    }
  }

  LinearGradient _getPastelGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        backgroundColor ?? DesignTokens.primaryLavender.withOpacity(0.3),
        DesignTokens.secondaryMint.withOpacity(0.2),
        DesignTokens.accentPeach.withOpacity(0.2),
      ],
    );
  }
}

/// Card style variants
enum StyledCardVariant {
  /// Standard elevated card with soft shadows
  elevated,

  /// Card with outlined border
  outlined,

  /// Card with watercolor-style irregular borders and shadows
  watercolor,

  /// Card with pastel gradient background
  gradient,
}

/// Specialized card for story/chapter content
class StoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final IconData? icon;

  const StoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StyledCard(
      variant: StyledCardVariant.watercolor,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(DesignTokens.spaceSm),
              decoration: BoxDecoration(
                color: DesignTokens.primaryLavender.withOpacity(0.3),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Icon(
                icon,
                size: DesignTokens.iconSizeLg,
                color: DesignTokens.textCharcoal,
              ),
            ),
            SizedBox(width: DesignTokens.spaceMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: DesignTokens.spaceXs),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: DesignTokens.neutralDark,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: DesignTokens.spaceMd),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Specialized card for game stats/progress
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accentColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return StyledCard(
      variant: StyledCardVariant.elevated,
      padding: EdgeInsets.all(DesignTokens.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: DesignTokens.iconSizeLg,
            color: color,
          ),
          SizedBox(height: DesignTokens.spaceSm),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: DesignTokens.spaceXs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.neutralDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
