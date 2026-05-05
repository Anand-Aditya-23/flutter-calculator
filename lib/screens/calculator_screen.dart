import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/display_panel.dart';
import '../widgets/button_grid.dart';
import '../widgets/history_drawer.dart';
import '../theme/app_theme.dart';

/// Root screen — assembles the display, button grid, and history drawer.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final size = MediaQuery.of(context).size;

    // Background gradient
    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E1A), Color(0xFF0D1528), Color(0xFF080C18)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F4FF), Color(0xFFE4ECF8), Color(0xFFEDF2FF)],
          );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // App name
                    Text(
                      'NeonCalc',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: isDark
                                ? [AppTheme.neonCyan, AppTheme.neonViolet]
                                : [const Color(0xFF4B00D4), const Color(0xFF0070CC)],
                          ).createShader(const Rect.fromLTWH(0, 0, 150, 30)),
                      ),
                    ),
                    Row(
                      children: [
                        // History button
                        Builder(builder: (ctx) {
                          return IconButton(
                            icon: Icon(
                              Icons.history_rounded,
                              color: isDark ? AppTheme.darkSubText : AppTheme.lightSubText,
                              size: 24,
                            ),
                            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                            tooltip: 'History',
                          );
                        }),
                        const SizedBox(width: 4),
                        // Theme toggle
                        _ThemeToggle(isDark: isDark),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Display ──────────────────────────────────────────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DisplayPanel(size: size),
                ),
              ),

              // ── Button Grid ──────────────────────────────────────
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  child: ButtonGrid(size: size),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: const HistoryDrawer(),
    );
  }
}

/// Animated sun/moon toggle button.
class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  const _ThemeToggle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ThemeProvider>().toggle(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1A2235), Color(0xFF243050)])
              : const LinearGradient(
                  colors: [Color(0xFFCDD5EE), Color(0xFFE0E8FF)]),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppTheme.neonCyan.withOpacity(0.2)
                  : const Color(0xFF4B00D4).withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isDark ? 26 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [AppTheme.neonCyan, AppTheme.neonViolet])
                      : const LinearGradient(
                          colors: [Color(0xFF4B00D4), Color(0xFF0070CC)]),
                ),
                child: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
