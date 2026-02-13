import 'package:flutter/material.dart';
import 'screens/responsive_home.dart';
import 'constants/retro_theme.dart';

void main() {
  runApp(const TaskPilotApp());
}

class TaskPilotApp extends StatelessWidget {
  const TaskPilotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskPilot',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RetroColors.neonPurple,
          brightness: Brightness.light,
        ),
        // Retro Typography
        fontFamily: 'Courier',
        // AppBar Styling
        appBarTheme: AppBarTheme(
          backgroundColor: RetroColors.neonPurple,
          elevation: 8,
          iconTheme: const IconThemeData(color: RetroColors.retroWhite),
          titleTextStyle: RetroTypography.retroHeadline.copyWith(
            color: RetroColors.retroWhite,
          ),
        ),
        // Button Styling
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
          ),
        ),
        // Text Button Styling
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: RetroColors.neonPurple,
            textStyle: RetroTypography.retroBody,
          ),
        ),
        // Input Decoration
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
        // Card Styling
        cardTheme: CardTheme(
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
        // Scaffold Background
        scaffoldBackgroundColor: RetroColors.retroWhite,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: RetroColors.neonPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light,
      home: const ResponsiveHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
