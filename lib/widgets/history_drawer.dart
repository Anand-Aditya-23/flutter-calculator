import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_entry.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// Side drawer that shows previous calculations.
class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    final bgColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final accentColor = isDark ? AppTheme.neonCyan : const Color(0xFF4B00D4);
    final textColor = isDark ? AppTheme.darkText : AppTheme.lightText;
    final subTextColor = isDark ? AppTheme.darkSubText : AppTheme.lightSubText;

    return Drawer(
      backgroundColor: bgColor,
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  if (calc.history.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        calc.clearHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('History cleared'),
                            backgroundColor: accentColor.withOpacity(0.9),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                      label: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── List ───────────────────────────────────────────────
            Expanded(
              child: calc.history.isEmpty
                  ? _EmptyState(isDark: isDark, subTextColor: subTextColor)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: calc.history.length,
                      itemBuilder: (context, i) {
                        return _HistoryCard(
                          entry: calc.history[i],
                          cardColor: cardColor,
                          accentColor: accentColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          onTap: () {
                            calc.loadFromHistory(calc.history[i]);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryEntry entry;
  final Color cardColor;
  final Color accentColor;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.entry,
    required this.cardColor,
    required this.accentColor,
    required this.textColor,
    required this.subTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = entry.timestamp;
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.expression,
                    style: AppTheme.monoStyle(size: 13, color: subTextColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '= ${entry.result}',
                    style: AppTheme.monoStyle(
                      size: 18,
                      weight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeStr, style: AppTheme.monoStyle(size: 11, color: subTextColor)),
                const SizedBox(height: 4),
                Icon(Icons.north_west_rounded, color: accentColor, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final Color subTextColor;

  const _EmptyState({required this.isDark, required this.subTextColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calculate_outlined,
            size: 56,
            color: subTextColor.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'No calculations yet',
            style: TextStyle(
              color: subTextColor,
              fontSize: 15,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your history will appear here',
            style: TextStyle(
              color: subTextColor.withOpacity(0.6),
              fontSize: 12,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }
}
