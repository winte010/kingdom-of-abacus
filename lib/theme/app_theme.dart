import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app colors that match the pastel theme
class AppColors {
  // Primary colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  // Secondary colors
  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;

  // Accent colors
  final Color accent;
  final Color accentDark;
  final Color accentLight;

  // Semantic colors
  final Color success;
  final Color successDark;
  final Color successLight;
  final Color warning;
  final Color warningDark;
  final Color warningLight;
  final Color error;
  final Color errorDark;
  final Color errorLight;
  final Color info;
  final Color infoDark;
  final Color infoLight;

  // Surface colors
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color outline;
  final Color shadow;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color scrim;

  // On colors
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color onAccent;
  final Color onSuccess;
  final Color onWarning;
  final Color onError;
  final Color onInfo;
  final Color onBackground;
  final Color onSurface;
  final Color onSurfaceVariant;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    required this.accent,
    required this.accentDark,
    required this.accentLight,
    required this.success,
    required this.successDark,
    required this.successLight,
    required this.warning,
    required this.warningDark,
    required this.warningLight,
    required this.error,
    required this.errorDark,
    required this.errorLight,
    required this.info,
    required this.infoDark,
    required this.infoLight,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.outline,
    required this.shadow,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.scrim,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.onAccent,
    required this.onSuccess,
    required this.onWarning,
    required this.onError,
    required this.onInfo,
    required this.onBackground,
    required this.onSurface,
    required this.onSurfaceVariant,
  });

  factory AppColors.fromJson(Map<String, dynamic> json) {
    return AppColors(
      primary: _parseColor(json['primary']),
      primaryDark: _parseColor(json['primaryDark']),
      primaryLight: _parseColor(json['primaryLight']),
      secondary: _parseColor(json['secondary']),
      secondaryDark: _parseColor(json['secondaryDark']),
      secondaryLight: _parseColor(json['secondaryLight']),
      accent: _parseColor(json['accent']),
      accentDark: _parseColor(json['accentDark']),
      accentLight: _parseColor(json['accentLight']),
      success: _parseColor(json['success']),
      successDark: _parseColor(json['successDark']),
      successLight: _parseColor(json['successLight']),
      warning: _parseColor(json['warning']),
      warningDark: _parseColor(json['warningDark']),
      warningLight: _parseColor(json['warningLight']),
      error: _parseColor(json['error']),
      errorDark: _parseColor(json['errorDark']),
      errorLight: _parseColor(json['errorLight']),
      info: _parseColor(json['info']),
      infoDark: _parseColor(json['infoDark']),
      infoLight: _parseColor(json['infoLight']),
      background: _parseColor(json['background']),
      surface: _parseColor(json['surface']),
      surfaceVariant: _parseColor(json['surfaceVariant']),
      outline: _parseColor(json['outline']),
      shadow: _parseColor(json['shadow']),
      inverseSurface: _parseColor(json['inverseSurface']),
      inverseOnSurface: _parseColor(json['inverseOnSurface']),
      inversePrimary: _parseColor(json['inversePrimary']),
      scrim: _parseColor(json['scrim']),
      onPrimary: _parseColor(json['onPrimary']),
      onPrimaryContainer: _parseColor(json['onPrimaryContainer']),
      onSecondary: _parseColor(json['onSecondary']),
      onSecondaryContainer: _parseColor(json['onSecondaryContainer']),
      onAccent: _parseColor(json['onAccent']),
      onSuccess: _parseColor(json['onSuccess']),
      onWarning: _parseColor(json['onWarning']),
      onError: _parseColor(json['onError']),
      onInfo: _parseColor(json['onInfo']),
      onBackground: _parseColor(json['onBackground']),
      onSurface: _parseColor(json['onSurface']),
      onSurfaceVariant: _parseColor(json['onSurfaceVariant']),
    );
  }

  static Color _parseColor(String hex) {
    final hexColor = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}

/// Spacing values
class AppSpacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  factory AppSpacing.fromJson(Map<String, dynamic> json) {
    return AppSpacing(
      xs: (json['xs'] as num).toDouble(),
      sm: (json['sm'] as num).toDouble(),
      md: (json['md'] as num).toDouble(),
      lg: (json['lg'] as num).toDouble(),
      xl: (json['xl'] as num).toDouble(),
      xxl: (json['xxl'] as num).toDouble(),
      xxxl: (json['xxxl'] as num).toDouble(),
    );
  }
}

/// Border radius values
class AppBorderRadius {
  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double full;

  const AppBorderRadius({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.full,
  });

  factory AppBorderRadius.fromJson(Map<String, dynamic> json) {
    return AppBorderRadius(
      none: (json['none'] as num).toDouble(),
      sm: (json['sm'] as num).toDouble(),
      md: (json['md'] as num).toDouble(),
      lg: (json['lg'] as num).toDouble(),
      xl: (json['xl'] as num).toDouble(),
      xxl: (json['xxl'] as num).toDouble(),
      full: (json['full'] as num).toDouble(),
    );
  }
}

/// Elevation values
class AppElevation {
  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const AppElevation({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AppElevation.fromJson(Map<String, dynamic> json) {
    return AppElevation(
      none: (json['none'] as num).toDouble(),
      sm: (json['sm'] as num).toDouble(),
      md: (json['md'] as num).toDouble(),
      lg: (json['lg'] as num).toDouble(),
      xl: (json['xl'] as num).toDouble(),
      xxl: (json['xxl'] as num).toDouble(),
    );
  }
}

/// Main theme configuration
class AppThemeConfig {
  final AppColors colors;
  final AppSpacing spacing;
  final AppBorderRadius borderRadius;
  final AppElevation elevation;
  final Map<String, dynamic> typography;

  const AppThemeConfig({
    required this.colors,
    required this.spacing,
    required this.borderRadius,
    required this.elevation,
    required this.typography,
  });

  factory AppThemeConfig.fromJson(Map<String, dynamic> json) {
    return AppThemeConfig(
      colors: AppColors.fromJson(json['colors']),
      spacing: AppSpacing.fromJson(json['spacing']),
      borderRadius: AppBorderRadius.fromJson(json['borderRadius']),
      elevation: AppElevation.fromJson(json['elevation']),
      typography: json['typography'],
    );
  }

  /// Load theme from JSON file
  static Future<AppThemeConfig> load() async {
    final jsonString =
        await rootBundle.loadString('assets/config/theme.json');
    final json = jsonDecode(jsonString);
    return AppThemeConfig.fromJson(json);
  }
}

/// App theme manager
class AppTheme {
  static AppThemeConfig? _config;
  static AppColors? _colors;
  static AppSpacing? _spacing;
  static AppBorderRadius? _borderRadius;
  static AppElevation? _elevation;

  /// Initialize the theme
  static Future<void> initialize() async {
    _config = await AppThemeConfig.load();
    _colors = _config!.colors;
    _spacing = _config!.spacing;
    _borderRadius = _config!.borderRadius;
    _elevation = _config!.elevation;
  }

  /// Get the current theme colors
  static AppColors get colors {
    assert(_colors != null, 'AppTheme not initialized. Call initialize() first.');
    return _colors!;
  }

  /// Get the current spacing values
  static AppSpacing get spacing {
    assert(_spacing != null, 'AppTheme not initialized. Call initialize() first.');
    return _spacing!;
  }

  /// Get the current border radius values
  static AppBorderRadius get borderRadius {
    assert(_borderRadius != null, 'AppTheme not initialized. Call initialize() first.');
    return _borderRadius!;
  }

  /// Get the current elevation values
  static AppElevation get elevation {
    assert(_elevation != null, 'AppTheme not initialized. Call initialize() first.');
    return _elevation!;
  }

  /// Generate Flutter ThemeData from config
  static ThemeData get lightTheme {
    assert(_config != null, 'AppTheme not initialized. Call initialize() first.');

    final colors = _config!.colors;
    final typography = _config!.typography;

    // Get font sizes
    final sizes = typography['sizes'] as Map<String, dynamic>;

    // Create text theme with Merriweather for story and Nunito for body
    final textTheme = TextTheme(
      // Display styles (for large headings)
      displayLarge: GoogleFonts.crimsonText(
        fontSize: sizes['displayLarge'],
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      displayMedium: GoogleFonts.crimsonText(
        fontSize: sizes['displayMedium'],
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),
      displaySmall: GoogleFonts.crimsonText(
        fontSize: sizes['displaySmall'],
        fontWeight: FontWeight.w400,
        color: colors.onBackground,
      ),

      // Headline styles (for section headings)
      headlineLarge: GoogleFonts.crimsonText(
        fontSize: sizes['headlineLarge'],
        fontWeight: FontWeight.w700,
        color: colors.onBackground,
      ),
      headlineMedium: GoogleFonts.crimsonText(
        fontSize: sizes['headlineMedium'],
        fontWeight: FontWeight.w600,
        color: colors.onBackground,
      ),
      headlineSmall: GoogleFonts.crimsonText(
        fontSize: sizes['headlineSmall'],
        fontWeight: FontWeight.w600,
        color: colors.onBackground,
      ),

      // Title styles (for card titles, list items)
      titleLarge: GoogleFonts.nunito(
        fontSize: sizes['titleLarge'],
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: sizes['titleMedium'],
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: sizes['titleSmall'],
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),

      // Body styles (for general text)
      bodyLarge: GoogleFonts.nunito(
        fontSize: sizes['bodyLarge'],
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: sizes['bodyMedium'],
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: sizes['bodySmall'],
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceVariant,
      ),

      // Label styles (for buttons, chips, etc.)
      labelLarge: GoogleFonts.quicksand(
        fontSize: sizes['labelLarge'],
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      labelMedium: GoogleFonts.quicksand(
        fontSize: sizes['labelMedium'],
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      labelSmall: GoogleFonts.quicksand(
        fontSize: sizes['labelSmall'],
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryLight,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        secondaryContainer: colors.secondaryLight,
        onSecondaryContainer: colors.onSecondaryContainer,
        tertiary: colors.accent,
        onTertiary: colors.onAccent,
        error: colors.errorDark,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceVariant,
        onSurfaceVariant: colors.onSurfaceVariant,
        outline: colors.outline,
        shadow: colors.shadow,
        inverseSurface: colors.inverseSurface,
        onInverseSurface: colors.inverseOnSurface,
        inversePrimary: colors.inversePrimary,
        scrim: colors.scrim,
      ),
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,

      // Card theme
      cardTheme: CardTheme(
        elevation: _elevation!.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius!.lg),
        ),
        color: colors.surface,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: _elevation!.none,
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: sizes['titleLarge'],
          fontWeight: FontWeight.w700,
          color: colors.onPrimary,
        ),
      ),

      // ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: _elevation!.sm,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: GoogleFonts.quicksand(
            fontSize: sizes['labelLarge'],
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius!.md),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _spacing!.lg,
            vertical: _spacing!.md,
          ),
        ),
      ),

      // TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: GoogleFonts.quicksand(
            fontSize: sizes['labelLarge'],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colors.onSurface,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius!.md),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius!.md),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius!.md),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        elevation: _elevation!.lg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius!.xl),
        ),
        backgroundColor: colors.surface,
      ),
    );
  }

  /// Dark theme (placeholder for future implementation)
  static ThemeData get darkTheme {
    // TODO: Implement dark theme
    return lightTheme;
  }
}

/// Story text style helper for book pages
TextStyle getStoryTextStyle(BuildContext context) {
  return GoogleFonts.merriweather(
    fontSize: 18,
    height: 1.8,
    fontWeight: FontWeight.w300,
    color: AppTheme.colors.onBackground,
  );
}
