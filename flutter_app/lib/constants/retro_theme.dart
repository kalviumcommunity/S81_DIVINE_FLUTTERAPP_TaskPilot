import 'package:flutter/material.dart';

/// Retro 90s Color Palette
class RetroColors {
  // Neon Colors (90s Vibe)
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonOrange = Color(0xFFFF8C00);

  // Retro Neutrals
  static const Color retroWhite = Color(0xFFF5F5F5);
  static const Color retroGray = Color(0xFF808080);
  static const Color retroBlack = Color(0xFF1A1A1A);
  static const Color retroDarkGray = Color(0xFF2D2D2D);

  // Retro Pastels
  static const Color pastelBlue = Color(0xFFADD8E6);
  static const Color pastelPink = Color(0xFFFFB6C1);
  static const Color pastelYellow = Color(0xFFFFFFCC);
  static const Color pastelGreen = Color(0xFFB0F8B0);

  // Aliases used in demos
  static const Color retroPink = pastelPink;

  // Status Colors
  static const Color success = Color(0xFF00DA6F);
  static const Color warning = Color(0xFFFFB81C);
  static const Color error = Color(0xFFFF0044);
  static const Color info = Color(0xFF0099FF);

  // UI Colors for Demos
  static const Color retroBlue = Color(0xFF0066CC);
  static const Color retroGreen = Color(0xFF00AA00);
  static const Color retroYellow = Color(0xFFFFCC00);
  static const Color retroRed = Color(0xFFCC0000);
  static const Color retrofaded = Color(0xFFF0F0F0);
}

/// Retro Typography
class RetroTypography {
  static const String courierNew = 'Courier';
  static const String vt323 = 'VT323';

  // Text Styles
  static const TextStyle retroDisplayLarge = TextStyle(
    fontFamily: vt323,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: RetroColors.neonPurple,
    letterSpacing: 2,
  );

  static const TextStyle retroDisplayMedium = TextStyle(
    fontFamily: vt323,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: RetroColors.neonCyan,
    letterSpacing: 1.5,
  );

  static const TextStyle retroHeadline = TextStyle(
    fontFamily: courierNew,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: RetroColors.retroBlack,
  );

  static const TextStyle retroTitle = TextStyle(
    fontFamily: courierNew,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: RetroColors.retroBlack,
  );

  static const TextStyle retroBody = TextStyle(
    fontFamily: courierNew,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: RetroColors.retroBlack,
  );

  static const TextStyle retroLabel = TextStyle(
    fontFamily: courierNew,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: RetroColors.retroGray,
  );
}

/// Retro Shadows & Depth Effects
class RetroEffects {
  // Soft Shadow (80s Look)
  static final BoxShadow softShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 8,
    offset: const Offset(2, 2),
  );

  // Deep Shadow (3D Effect)
  static final BoxShadow deepShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 16,
    offset: const Offset(4, 8),
  );

  // Neon Glow
  static final BoxShadow neonGlow = BoxShadow(
    color: RetroColors.neonPurple.withOpacity(0.5),
    blurRadius: 20,
    spreadRadius: 2,
  );

  // Neumorphic Light
  static const List<BoxShadow> neumorphicLight = [
    BoxShadow(
      color: Colors.white,
      blurRadius: 15,
      offset: Offset(-5, -5),
    ),
    BoxShadow(
      color: Color(0xFFBEBEBE),
      blurRadius: 15,
      offset: Offset(5, 5),
    ),
  ];

  // Neumorphic Dark
  static const List<BoxShadow> neumorphicDark = [
    BoxShadow(
      color: Color(0xFF000000),
      blurRadius: 15,
      offset: Offset(-5, -5),
    ),
    BoxShadow(
      color: Color(0xFF1A1A1A),
      blurRadius: 15,
      offset: Offset(5, 5),
    ),
  ];
}

/// Spacing Constants
class RetroSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius
class RetroBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const Radius xsRadius = Radius.circular(xs);
  static const Radius smRadius = Radius.circular(sm);
  static const Radius mdRadius = Radius.circular(md);
  static const Radius lgRadius = Radius.circular(lg);
  static const Radius xlRadius = Radius.circular(xl);
}

/// Centralized app theme builder.
///
/// Keeps colors + text styles consistent across screens by providing a single
/// `ThemeData` definition (instead of styling each screen ad-hoc).
class RetroAppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: RetroColors.neonPurple,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme(Brightness.light),
      fontFamily: RetroTypography.courierNew,
      scaffoldBackgroundColor: RetroColors.retroWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: RetroColors.neonPurple,
        elevation: 8,
        iconTheme: const IconThemeData(color: RetroColors.retroWhite),
        titleTextStyle: RetroTypography.retroHeadline.copyWith(
          color: RetroColors.retroWhite,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: RetroColors.neonPurple.withOpacity(0.25),
        thickness: 2,
        space: RetroSpacing.lg,
      ),
      iconTheme: const IconThemeData(color: RetroColors.neonPurple),
      listTileTheme: ListTileThemeData(
        iconColor: RetroColors.neonPurple,
        textColor: RetroColors.retroBlack,
        titleTextStyle: RetroTypography.retroTitle,
        subtitleTextStyle: RetroTypography.retroBody.copyWith(
          color: RetroColors.retroGray,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RetroColors.neonPurple,
          foregroundColor: RetroColors.retroWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: RetroSpacing.md,
            vertical: RetroSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
          ),
          elevation: 8,
          textStyle: RetroTypography.retroTitle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: RetroColors.neonPurple,
          textStyle: RetroTypography.retroBody,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RetroColors.retroWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
          borderSide: const BorderSide(
            color: RetroColors.neonPurple,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
          borderSide: BorderSide(
            color: RetroColors.neonPurple.withOpacity(0.5),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
          borderSide: const BorderSide(
            color: RetroColors.neonCyan,
            width: 2,
          ),
        ),
        labelStyle: RetroTypography.retroLabel,
        hintStyle: RetroTypography.retroLabel.copyWith(
          color: RetroColors.retroGray.withOpacity(0.6),
        ),
        contentPadding: const EdgeInsets.all(RetroSpacing.md),
      ),
      cardTheme: CardThemeData(
        color: RetroColors.retroWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RetroBorderRadius.md),
          side: const BorderSide(
            color: RetroColors.neonPurple,
            width: 2,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: RetroColors.neonPurple,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      textTheme: _textTheme(Brightness.dark),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final onSurface = brightness == Brightness.dark
        ? Colors.white
        : RetroColors.retroBlack;
    final muted = brightness == Brightness.dark
        ? Colors.white70
        : RetroColors.retroGray;

    return TextTheme(
      displayLarge: RetroTypography.retroDisplayLarge.copyWith(color: onSurface),
      displayMedium:
          RetroTypography.retroDisplayMedium.copyWith(color: onSurface),
      headlineMedium: RetroTypography.retroHeadline.copyWith(color: onSurface),
      headlineSmall: RetroTypography.retroHeadline.copyWith(color: onSurface),
      titleLarge: RetroTypography.retroTitle.copyWith(color: onSurface),
      titleMedium: RetroTypography.retroTitle.copyWith(color: onSurface),
      bodyLarge: RetroTypography.retroBody.copyWith(color: onSurface),
      bodyMedium: RetroTypography.retroBody.copyWith(color: onSurface),
      labelLarge: RetroTypography.retroLabel.copyWith(color: muted),
      labelMedium: RetroTypography.retroLabel.copyWith(color: muted),
    );
  }
}
