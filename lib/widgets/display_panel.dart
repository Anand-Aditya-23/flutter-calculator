import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// The top section showing the expression and result.
class DisplayPanel extends StatelessWidget {
  final Size size;
  const DisplayPanel({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final accentColor = isDark ? AppTheme.neonCyan : const Color(0xFF4B00D4);
    final subTextColor = isDark ? AppTheme.darkSubText : AppTheme.lightSubText;
    final mainTextColor = isDark ? AppTheme.darkText : AppTheme.lightText;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accentColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(isDark ? 0.08 : 0.06),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ── Live expression (small, top) ─────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              calc.expression.isEmpty ? ' ' : calc.expression,
              key: ValueKey(calc.expression),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.monoStyle(
                size: 16,
                color: subTextColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Main display number ──────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                calc.display,
                key: ValueKey(calc.display),
                textAlign: TextAlign.right,
                style: AppTheme.monoStyle(
                  size: 64,
                  weight: FontWeight.bold,
                  color: calc.display == 'Error'
                      ? Colors.redAccent
                      : mainTextColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ── Live result preview ──────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: calc.liveResult.isNotEmpty && !calc.justEvaluated
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '= ',
                        style: AppTheme.monoStyle(
                            size: 18, color: accentColor.withOpacity(0.6)),
                      ),
                      Text(
                        calc.liveResult,
                        key: ValueKey(calc.liveResult),
                        style: AppTheme.monoStyle(
                          size: 20,
                          color: accentColor,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(height: 24, key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}
