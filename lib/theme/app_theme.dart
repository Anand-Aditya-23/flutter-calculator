import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central theme configuration for NeonCalc.
/// Dark theme uses deep navy + electric cyan/violet accents.
/// Light theme uses soft white + deep indigo accents.
class AppTheme {
  // ── Brand Colors ────────────────────────────────────────────────
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonViolet = Color(0xFFB040FF);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonOrange = Color(0xFFFF6D00);

  // Dark palette
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2235);
  static const Color darkBtnDefault = Color(0xFF1E2D45);
  static const Color darkBtnOperator = Color(0xFF1A1F3A);
  static const Color darkText = Color(0xFFECF0FF);
  static const Color darkSubText = Color(0xFF7B8DB0);

  // Light palette
  static const Color lightBg = Color(0xFFF0F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFE8EEF8);
  static const Color lightBtnDefault = Color(0xFFDDE4F5);
  static const Color lightBtnOperator = Color(0xFFCDD5EE);
  static const Color lightText = Color(0xFF0D1B3E);
  static const Color lightSubText = Color(0xFF5A6A8A);

  // ── Text Style Helper ────────────────────────────────────────────
  static TextStyle monoStyle({
    double size = 16,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    // JetBrains Mono is available via google_fonts package
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.5,
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonViolet,
        surface: darkSurface,
        onPrimary: darkBg,
        onSecondary: darkBg,
        onSurface: darkText,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ),
      useMaterial3: true,
    );
  }

  // ── Light Theme ──────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4B00D4),
        secondary: Color(0xFF0070CC),
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ),
      useMaterial3: true,
    );
  }
}
