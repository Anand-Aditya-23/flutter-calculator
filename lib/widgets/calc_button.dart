import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A single pressable calculator button with ripple + scale animation.
class CalcButton extends StatefulWidget {
  final String label;
  final String type; // 'digit' | 'operator' | 'action' | 'equals' | 'func'
  final bool isDark;
  final VoidCallback onPressed;

  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTapDown(_) => _ctrl.forward();
  void _handleTapUp(_) {
    _ctrl.reverse();
    widget.onPressed();
  }
  void _handleTapCancel() => _ctrl.reverse();

  // ── Color Lookups ────────────────────────────────────────────────
  Color _bgColor() {
    final d = widget.isDark;
    switch (widget.type) {
      case 'equals':
        return d ? AppTheme.neonCyan : const Color(0xFF4B00D4);
      case 'operator':
        return d ? const Color(0xFF1A1F3A) : const Color(0xFFCDD5EE);
      case 'action':
        return d ? const Color(0xFF1E2A40) : const Color(0xFFD5DCEE);
      case 'func':
        return d ? const Color(0xFF14192E) : const Color(0xFFDDE4F5);
      default: // digit
        return d ? AppTheme.darkBtnDefault : AppTheme.lightBtnDefault;
    }
  }

  Color _textColor() {
    final d = widget.isDark;
    switch (widget.type) {
      case 'equals':
        return d ? AppTheme.darkBg : Colors.white;
      case 'operator':
        return d ? AppTheme.neonCyan : const Color(0xFF4B00D4);
      case 'action':
        return d ? AppTheme.neonViolet : const Color(0xFF0070CC);
      case 'func':
        return d ? AppTheme.neonGreen : const Color(0xFF007A3D);
      default:
        return d ? AppTheme.darkText : AppTheme.lightText;
    }
  }

  Color _glowColor() {
    switch (widget.type) {
      case 'equals':
        return AppTheme.neonCyan;
      case 'operator':
        return AppTheme.neonCyan;
      case 'action':
        return AppTheme.neonViolet;
      case 'func':
        return AppTheme.neonGreen;
      default:
        return AppTheme.darkText;
    }
  }

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final glowOpacity = widget.isDark ? _glow.value * 0.35 : _glow.value * 0.2;
          final bgCol = _bgColor();
          final txtCol = _textColor();
          final glowCol = _glowColor();

          return Transform.scale(
            scale: _scale.value,
            child: Container(
              constraints: const BoxConstraints(minHeight: 56, maxHeight: 80),
              decoration: BoxDecoration(
                color: bgCol,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  // Depth shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDark ? 0.4 : 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  // Neon glow on press
                  if (glowOpacity > 0)
                    BoxShadow(
                      color: glowCol.withOpacity(glowOpacity),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                ],
                border: Border.all(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.7),
                  width: 1,
                ),
              ),
              child: Center(
                child: _ButtonContent(label: widget.label, color: txtCol),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Renders the label — uses icon for backspace, text otherwise.
class _ButtonContent extends StatelessWidget {
  final String label;
  final Color color;

  const _ButtonContent({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    if (label == '⌫') {
      return Icon(Icons.backspace_outlined, color: color, size: 22);
    }

    // Slightly larger font for digits and equals
    final isLarge = RegExp(r'[0-9=+\-×÷]').hasMatch(label);

    return Text(
      label,
      style: AppTheme.monoStyle(
        size: isLarge ? 26 : 20,
        weight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
