import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_logic.dart';
import '../models/history_entry.dart';

/// ChangeNotifier that bridges [CalculatorLogic] with the UI.
/// Also persists calculation history via SharedPreferences.
class CalculatorProvider extends ChangeNotifier {
  final CalculatorLogic _logic = CalculatorLogic();

  // History
  final List<HistoryEntry> _history = [];
  static const _historyKey = 'calc_history';

  // Haptic / animation trigger
  bool _buttonJustPressed = false;
  String _lastButton = '';

  // ── Getters ──────────────────────────────────────────────────────
  String get display => _logic.display;
  String get expression => _logic.expression;
  String get liveResult => _logic.result;
  bool get justEvaluated => _logic.justEvaluated;
  List<HistoryEntry> get history => List.unmodifiable(_history);
  bool get buttonJustPressed => _buttonJustPressed;
  String get lastButton => _lastButton;

  CalculatorProvider() {
    _loadHistory();
  }

  // ── Button Press ─────────────────────────────────────────────────
  void onButton(String label) {
    // Capture state before press for history
    final exprBefore = _logic.expression;

    _buttonJustPressed = true;
    _lastButton = label;

    _logic.input(label);

    // If "=" was pressed and we got a result, save to history
    if (label == '=' && _logic.justEvaluated && exprBefore.isNotEmpty) {
      final entry = HistoryEntry(
        expression: exprBefore,
        result: _logic.result,
        timestamp: DateTime.now(),
      );
      _history.insert(0, entry);
      if (_history.length > 50) _history.removeLast(); // cap at 50
      _saveHistory();
    }

    notifyListeners();

    // Reset button-press flag after a short delay (for animations)
    Future.delayed(const Duration(milliseconds: 120), () {
      _buttonJustPressed = false;
      notifyListeners();
    });
  }

  /// Load a result from history into the display.
  void loadFromHistory(HistoryEntry entry) {
    _logic.input('AC');
    for (final ch in entry.result.split('')) {
      _logic.input(ch);
    }
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  // ── Persistence ──────────────────────────────────────────────────
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_history.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_historyKey);
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        _history.addAll(list.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)));
        notifyListeners();
      }
    } catch (_) {
      // If loading fails, start with empty history
    }
  }
}
