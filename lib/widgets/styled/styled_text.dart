import 'package:flutter/material.dart';
import '../../config/design_tokens.dart';

/// Styled text components with proper font hierarchy
/// Maintains separation between presentation and business logic
class StyledText extends StatelessWidget {
  final String text;
  final StyledTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const StyledText(
    this.text, {
    super.key,
    this.variant = StyledTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  });

  /// Heading 1 - largest heading
  const StyledText.h1(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.h1;

  /// Heading 2
  const StyledText.h2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.h2;

  /// Heading 3
  const StyledText.h3(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.h3;

  /// Body text
  const StyledText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.body;

  /// Small body text
  const StyledText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.bodySmall;

  /// Caption text
  const StyledText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.caption;

  /// Math number display - clear, large serif
  const StyledText.mathNumber(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  }) : variant = StyledTextVariant.mathNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _getTextStyle(theme);

    return Text(
      text,
      style: textStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? _getTextStyle(ThemeData theme) {
    switch (variant) {
      case StyledTextVariant.h1:
        return theme.textTheme.displayMedium;
      case StyledTextVariant.h2:
        return theme.textTheme.headlineMedium;
      case StyledTextVariant.h3:
        return theme.textTheme.titleLarge;
      case StyledTextVariant.body:
        return theme.textTheme.bodyLarge;
      case StyledTextVariant.bodySmall:
        return theme.textTheme.bodyMedium;
      case StyledTextVariant.caption:
        return theme.textTheme.bodySmall;
      case StyledTextVariant.mathNumber:
        return theme.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        );
    }
  }
}

/// Text style variants
enum StyledTextVariant {
  h1,
  h2,
  h3,
  body,
  bodySmall,
  caption,
  mathNumber,
}

/// Story text with decorative styling
class StoryText extends StatelessWidget {
  final String text;
  final bool isNarration;

  const StoryText({
    super.key,
    required this.text,
    this.isNarration = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(DesignTokens.spaceMd),
      decoration: BoxDecoration(
        color: isNarration
            ? DesignTokens.primaryLavender.withOpacity(0.1)
            : DesignTokens.secondaryMint.withOpacity(0.1),
        borderRadius: DesignTokens.irregularBorderRadius,
        border: Border.all(
          color: isNarration
              ? DesignTokens.primaryLavender.withOpacity(0.3)
              : DesignTokens.secondaryMint.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontStyle: isNarration ? FontStyle.italic : FontStyle.normal,
          height: 1.6,
        ),
      ),
    );
  }
}

/// Label with background highlight
class HighlightedLabel extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const HighlightedLabel({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceSm,
        vertical: DesignTokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor ?? DesignTokens.textCharcoal,
        ),
      ),
    );
  }
}

/// Success message text
class SuccessText extends StatelessWidget {
  final String text;

  const SuccessText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: DesignTokens.successGreen,
          size: DesignTokens.iconSizeSm,
        ),
        SizedBox(width: DesignTokens.spaceXs),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: DesignTokens.successGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Error message text
class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          color: DesignTokens.errorCoral,
          size: DesignTokens.iconSizeSm,
        ),
        SizedBox(width: DesignTokens.spaceXs),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: DesignTokens.errorCoral,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Warning message text
class WarningText extends StatelessWidget {
  final String text;

  const WarningText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          color: DesignTokens.warningSoftYellow,
          size: DesignTokens.iconSizeSm,
        ),
        SizedBox(width: DesignTokens.spaceXs),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: DesignTokens.neutralDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
