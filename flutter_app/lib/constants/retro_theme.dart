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
  static const FontFamily courierNew = 'Courier';
  static const FontFamily vt323 = 'VT323';

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

/// Enum for font families
enum FontFamily { courier, vt323 }

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
