import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'calc_button.dart';

/// Layout of all calculator buttons in a responsive grid.
class ButtonGrid extends StatelessWidget {
  final Size size;

  const ButtonGrid({super.key, required this.size});

  // ── Button Layout Definition ─────────────────────────────────────
  // Each inner list is a row. Each entry: [label, type]
  // Types: 'digit', 'operator', 'action', 'equals', 'func'
  static const List<List<List<String>>> _rows = [
    // Row 1 — advanced functions
    [
      ['√', 'func'],
      ['^', 'func'],
      ['(', 'func'],
      [')', 'func'],
    ],
    // Row 2 — clear, sign, percent, divide
    [
      ['AC', 'action'],
      ['±', 'action'],
      ['%', 'action'],
      ['÷', 'operator'],
    ],
    // Row 3
    [
      ['7', 'digit'],
      ['8', 'digit'],
      ['9', 'digit'],
      ['×', 'operator'],
    ],
    // Row 4
    [
      ['4', 'digit'],
      ['5', 'digit'],
      ['6', 'digit'],
      ['−', 'operator'],
    ],
    // Row 5
    [
      ['1', 'digit'],
      ['2', 'digit'],
      ['3', 'digit'],
      ['+', 'operator'],
    ],
    // Row 6 — bottom row (0 is wide)
    [
      ['0', 'digit_wide'],
      ['.', 'digit'],
      ['=', 'equals'],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return LayoutBuilder(builder: (context, constraints) {
      final btnSpacing = constraints.maxWidth < 380 ? 8.0 : 10.0;
      final rowSpacing = constraints.maxHeight < 500 ? 6.0 : 10.0;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _rows.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((btnDef) {
              final label = btnDef[0];
              final type = btnDef[1];
              final isWide = type == 'digit_wide';

              return Expanded(
                flex: isWide ? 2 : 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: btnSpacing / 2,
                    vertical: rowSpacing / 2,
                  ),
                  child: CalcButton(
                    label: label,
                    type: isWide ? 'digit' : type,
                    isDark: isDark,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.read<CalculatorProvider>().onButton(label);
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    });
  }
}
