import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

/// Kingdom of Abacus theme configuration
/// Implements a soft pastel storybook aesthetic
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Main app theme with pastel colors and serif fonts
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // ==========================================
      // COLOR SCHEME
      // ==========================================
      colorScheme: ColorScheme.light(
        // Primary colors - Lavender
        primary: DesignTokens.primaryLavender,
        onPrimary: DesignTokens.textCharcoal,
        primaryContainer: DesignTokens.primaryLavender,
        onPrimaryContainer: DesignTokens.textCharcoal,

        // Secondary colors - Mint
        secondary: DesignTokens.secondaryMint,
        onSecondary: DesignTokens.textCharcoal,
        secondaryContainer: DesignTokens.secondaryMint,
        onSecondaryContainer: DesignTokens.textCharcoal,

        // Tertiary colors - Peach
        tertiary: DesignTokens.accentPeach,
        onTertiary: DesignTokens.textCharcoal,
        tertiaryContainer: DesignTokens.accentPeach,
        onTertiaryContainer: DesignTokens.textCharcoal,

        // Error colors - Soft Coral
        error: DesignTokens.errorCoral,
        onError: DesignTokens.textCharcoal,
        errorContainer: DesignTokens.errorCoral.withOpacity(0.3),
        onErrorContainer: DesignTokens.textCharcoal,

        // Surface colors - Cream backgrounds
        surface: DesignTokens.backgroundCream,
        onSurface: DesignTokens.textCharcoal,
        surfaceContainerHighest: DesignTokens.neutralLight,

        // Outline and borders
        outline: DesignTokens.neutralMedium,
        outlineVariant: DesignTokens.neutralLight,

        // Additional colors
        surfaceVariant: DesignTokens.neutralLight,
        onSurfaceVariant: DesignTokens.textCharcoal,
      ),

      // ==========================================
      // SCAFFOLD BACKGROUND
      // ==========================================
      scaffoldBackgroundColor: DesignTokens.backgroundCream,

      // ==========================================
      // TEXT THEME - Serif fonts for storybook feel
      // ==========================================
      textTheme: _buildTextTheme(),

      // ==========================================
      // APP BAR THEME
      // ==========================================
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.primaryLavender,
        foregroundColor: DesignTokens.textCharcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: FontWeight.bold,
          color: DesignTokens.textCharcoal,
        ),
        iconTheme: IconThemeData(
          color: DesignTokens.textCharcoal,
          size: DesignTokens.iconSizeMd,
        ),
      ),

      // ==========================================
      // CARD THEME - Watercolor shadows
      // ==========================================
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        margin: EdgeInsets.all(DesignTokens.spaceMd),
      ),

      // ==========================================
      // ELEVATED BUTTON THEME - Hand-drawn feel
      // ==========================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryLavender,
          foregroundColor: DesignTokens.textCharcoal,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLg,
            vertical: DesignTokens.spaceMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: DesignTokens.fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ==========================================
      // TEXT BUTTON THEME
      // ==========================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.textCharcoal,
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMd,
            vertical: DesignTokens.spaceSm,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: DesignTokens.fontSizeBody,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ==========================================
      // OUTLINED BUTTON THEME
      // ==========================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.textCharcoal,
          side: BorderSide(
            color: DesignTokens.primaryLavender,
            width: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLg,
            vertical: DesignTokens.spaceMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: DesignTokens.fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ==========================================
      // INPUT DECORATION THEME
      // ==========================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(DesignTokens.spaceMd),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: DesignTokens.neutralMedium,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: DesignTokens.neutralMedium,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: DesignTokens.primaryLavender,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: DesignTokens.errorCoral,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          borderSide: BorderSide(
            color: DesignTokens.errorCoral,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeBody,
          color: DesignTokens.textCharcoal,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeBody,
          color: DesignTokens.neutralDark,
        ),
      ),

      // ==========================================
      // DIALOG THEME
      // ==========================================
      dialogTheme: DialogTheme(
        backgroundColor: DesignTokens.backgroundCream,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: FontWeight.bold,
          color: DesignTokens.textCharcoal,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeBody,
          color: DesignTokens.textCharcoal,
        ),
      ),

      // ==========================================
      // FLOATING ACTION BUTTON THEME
      // ==========================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.accentPeach,
        foregroundColor: DesignTokens.textCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
      ),

      // ==========================================
      // CHIP THEME
      // ==========================================
      chipTheme: ChipThemeData(
        backgroundColor: DesignTokens.secondaryMint,
        deleteIconColor: DesignTokens.textCharcoal,
        labelStyle: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: DesignTokens.fontSizeSm,
          color: DesignTokens.textCharcoal,
        ),
        padding: EdgeInsets.all(DesignTokens.spaceSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
      ),

      // ==========================================
      // PROGRESS INDICATOR THEME
      // ==========================================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: DesignTokens.primaryLavender,
        linearTrackColor: DesignTokens.neutralLight,
        circularTrackColor: DesignTokens.neutralLight,
      ),

      // ==========================================
      // ICON THEME
      // ==========================================
      iconTheme: IconThemeData(
        color: DesignTokens.textCharcoal,
        size: DesignTokens.iconSizeMd,
      ),

      // ==========================================
      // DIVIDER THEME
      // ==========================================
      dividerTheme: DividerThemeData(
        color: DesignTokens.neutralMedium,
        thickness: 1,
        space: DesignTokens.spaceMd,
      ),
    );
  }

  /// Build text theme with serif fonts for storybook aesthetic
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // Display styles - largest text
      displayLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeDisplay,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeXl,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeXl,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeMd,
        fontWeight: FontWeight.bold,
        color: DesignTokens.textCharcoal,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeMd,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeBody,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeBody,
        fontWeight: FontWeight.normal,
        color: DesignTokens.textCharcoal,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.normal,
        color: DesignTokens.textCharcoal,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.normal,
        color: DesignTokens.textCharcoal,
        height: 1.5,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Georgia',
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 10.0,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textCharcoal,
      ),
    );
  }

  // ==========================================
  // CUSTOM DECORATIONS
  // ==========================================

  /// Watercolor-style box decoration for cards
  static BoxDecoration get watercolorCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        boxShadow: DesignTokens.shadowSoft,
      );

  /// Hand-drawn border decoration
  static BoxDecoration get handDrawnBorderDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.irregularBorderRadius,
        border: Border.all(
          color: DesignTokens.primaryLavender,
          width: 2,
        ),
        boxShadow: DesignTokens.shadowMedium,
      );

  /// Pastel gradient background
  static BoxDecoration get pastelGradientDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignTokens.backgroundCream,
            DesignTokens.primaryLavender.withOpacity(0.1),
            DesignTokens.secondaryMint.withOpacity(0.1),
          ],
        ),
      );
}
