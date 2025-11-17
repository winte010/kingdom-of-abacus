import 'package:flutter/material.dart';

/// Design tokens for Kingdom of Abacus
/// Contains all reusable design values for consistent styling
class DesignTokens {
  // Private constructor to prevent instantiation
  DesignTokens._();

  // ==========================================
  // PASTEL COLOR PALETTE
  // ==========================================

  /// Primary: Soft lavender - main brand color
  static const Color primaryLavender = Color(0xFFE6D5F5);

  /// Secondary: Mint green - secondary actions
  static const Color secondaryMint = Color(0xFFD5F5E3);

  /// Accent: Peachy orange - highlights and CTAs
  static const Color accentPeach = Color(0xFFFFD4C4);

  /// Background: Cream - main background
  static const Color backgroundCream = Color(0xFFFFF9F5);

  /// Text: Soft charcoal - primary text
  static const Color textCharcoal = Color(0xFF4A4A4A);

  /// Success: Soft green - success states
  static const Color successGreen = Color(0xFFB8E6CC);

  /// Error: Soft coral - error states
  static const Color errorCoral = Color(0xFFFFB8B8);

  /// Warning: Soft yellow - warning states
  static const Color warningSoftYellow = Color(0xFFFFF4CC);

  // Additional pastel shades for variety
  static const Color pastelBlue = Color(0xFFD4E4FF);
  static const Color pastelPink = Color(0xFFFFD4E5);
  static const Color pastelLemon = Color(0xFFFFF9D4);

  // Neutral shades
  static const Color neutralLight = Color(0xFFF5F5F5);
  static const Color neutralMedium = Color(0xFFE0E0E0);
  static const Color neutralDark = Color(0xFF757575);

  // ==========================================
  // SPACING SYSTEM
  // ==========================================

  /// Extra small spacing (4px)
  static const double spaceXs = 4.0;

  /// Small spacing (8px)
  static const double spaceSm = 8.0;

  /// Medium spacing (16px)
  static const double spaceMd = 16.0;

  /// Large spacing (24px)
  static const double spaceLg = 24.0;

  /// Extra large spacing (32px)
  static const double spaceXl = 32.0;

  /// Extra extra large spacing (48px)
  static const double spaceXxl = 48.0;

  // ==========================================
  // BORDER RADIUS (Hand-drawn feel)
  // ==========================================

  /// Small radius for subtle rounding (8px)
  static const double radiusSm = 8.0;

  /// Medium radius for cards and buttons (12px)
  static const double radiusMd = 12.0;

  /// Large radius for prominent elements (16px)
  static const double radiusLg = 16.0;

  /// Extra large radius for rounded containers (24px)
  static const double radiusXl = 24.0;

  /// Slightly irregular border radius for hand-drawn feel
  static BorderRadius get irregularBorderRadius => BorderRadius.only(
        topLeft: const Radius.circular(radiusMd),
        topRight: const Radius.circular(radiusMd + 2),
        bottomLeft: const Radius.circular(radiusMd + 1),
        bottomRight: const Radius.circular(radiusMd),
      );

  // ==========================================
  // SHADOWS (Watercolor-style)
  // ==========================================

  /// Subtle elevation for cards - soft watercolor effect
  static List<BoxShadow> get shadowSoft => [
        BoxShadow(
          color: primaryLavender.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: secondaryMint.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(2, 2),
          spreadRadius: 0,
        ),
      ];

  /// Medium elevation - more pronounced watercolor
  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: primaryLavender.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: accentPeach.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(3, 3),
          spreadRadius: 0,
        ),
      ];

  /// Strong elevation for overlays
  static List<BoxShadow> get shadowStrong => [
        BoxShadow(
          color: primaryLavender.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: secondaryMint.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(4, 4),
          spreadRadius: 0,
        ),
      ];

  // ==========================================
  // ANIMATION DURATIONS
  // ==========================================

  /// Fast animation (150ms) - micro-interactions
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Normal animation (300ms) - standard transitions
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animation (500ms) - emphasize important changes
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Very slow animation (800ms) - story moments
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // ==========================================
  // TYPOGRAPHY SIZES
  // ==========================================

  /// Extra small text (12px)
  static const double fontSizeXs = 12.0;

  /// Small text (14px)
  static const double fontSizeSm = 14.0;

  /// Body text (16px)
  static const double fontSizeBody = 16.0;

  /// Medium heading (18px)
  static const double fontSizeMd = 18.0;

  /// Large heading (24px)
  static const double fontSizeLg = 24.0;

  /// Extra large heading (32px)
  static const double fontSizeXl = 32.0;

  /// Display text (48px)
  static const double fontSizeDisplay = 48.0;

  // ==========================================
  // ICON SIZES
  // ==========================================

  /// Small icon (16px)
  static const double iconSizeSm = 16.0;

  /// Medium icon (24px)
  static const double iconSizeMd = 24.0;

  /// Large icon (32px)
  static const double iconSizeLg = 32.0;

  /// Extra large icon (48px)
  static const double iconSizeXl = 48.0;

  // ==========================================
  // OPACITY LEVELS
  // ==========================================

  /// Disabled state opacity
  static const double opacityDisabled = 0.5;

  /// Hover state opacity
  static const double opacityHover = 0.8;

  /// Overlay opacity
  static const double opacityOverlay = 0.6;
}
