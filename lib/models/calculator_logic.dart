/// Pure Dart calculator logic — no Flutter dependencies.
/// Handles expression parsing, evaluation, and edge cases.
library;

import 'dart:math' as math;

class CalculatorLogic {
  // ── State ────────────────────────────────────────────────────────
  String _expression = '';   // What the user is building
  String _display = '0';     // What shows on the main display
  String _result = '';       // Evaluated result (shown smaller above)
  bool _justEvaluated = false; // After pressing "=" the next number starts fresh

  // ── Getters ──────────────────────────────────────────────────────
  String get display => _display;
  String get expression => _expression;
  String get result => _result;
  bool get justEvaluated => _justEvaluated;

  // ── Input Handling ───────────────────────────────────────────────

  /// Process a button label and update internal state.
  /// Returns true if state changed (caller should rebuild).
  bool input(String btn) {
    switch (btn) {
      case 'AC':
        _allClear();
      case 'C':
        _clear();
      case '=':
        _evaluate();
      case '±':
        _toggleSign();
      case '%':
        _applyPercent();
      case '√':
        _applySqrt();
      case '^':
        _appendOperator('^');
      case '(':
      case ')':
        _appendParen(btn);
      case '+':
      case '−':
      case '×':
      case '÷':
        _appendOperator(btn);
      case '.':
        _appendDecimal();
      case '⌫':
        _backspace();
      default:
        // Digits 0-9
        _appendDigit(btn);
    }
    return true;
  }

  // ── Private Helpers ──────────────────────────────────────────────

  void _allClear() {
    _expression = '';
    _display = '0';
    _result = '';
    _justEvaluated = false;
  }

  void _clear() {
    if (_display != '0') {
      _display = '0';
      // Also remove last token from expression
      if (_expression.isNotEmpty) {
        // Remove last digit/group from expression
        _expression = _expression.trimRight();
        // Find the last operator or start
        final ops = ['+', '−', '×', '÷', '^', '('];
        int lastOp = -1;
        for (final op in ops) {
          final idx = _expression.lastIndexOf(op);
          if (idx > lastOp) lastOp = idx;
        }
        _expression = _expression.substring(0, lastOp + 1);
      }
    } else {
      _allClear();
    }
    _justEvaluated = false;
  }

  void _backspace() {
    if (_justEvaluated) {
      _allClear();
      return;
    }
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression.isEmpty ? '0' : _expression;
    }
    // Recalculate live result
    _liveEval();
  }

  void _appendDigit(String digit) {
    if (_justEvaluated) {
      // Start a fresh expression after "="
      _expression = digit;
      _display = digit;
      _justEvaluated = false;
    } else {
      if (_display == '0' && digit != '0' && !_expression.contains('.')) {
        // Replace leading zero
        if (_expression.endsWith('0') &&
            (_expression.length == 1 ||
             _isOperatorChar(_expression[_expression.length - 2]))) {
          _expression = _expression.substring(0, _expression.length - 1) + digit;
        } else {
          _expression += digit;
        }
      } else {
        _expression += digit;
      }
      _display = _currentToken();
    }
    _liveEval();
  }

  void _appendOperator(String op) {
    if (_expression.isEmpty && op != '−') return; // can't start with operator except minus

    // Replace trailing operator
    if (_expression.isNotEmpty && _isOperatorChar(_expression[_expression.length - 1])) {
      _expression = _expression.substring(0, _expression.length - 1) + op;
    } else {
      if (_justEvaluated && _result.isNotEmpty) {
        _expression = _result + op;
        _justEvaluated = false;
      } else {
        _expression += op;
      }
    }
    _display = op;
  }

  void _appendParen(String p) {
    if (_justEvaluated) {
      if (p == '(') {
        _expression = '(';
        _display = '(';
        _justEvaluated = false;
      }
      return;
    }
    _expression += p;
    _display = p;
    _liveEval();
  }

  void _appendDecimal() {
    final token = _currentToken();
    if (token.contains('.')) return; // already has decimal
    if (_justEvaluated) {
      _expression = '0.';
      _display = '0.';
      _justEvaluated = false;
      return;
    }
    if (_expression.isEmpty || _isOperatorChar(_expression[_expression.length - 1])) {
      _expression += '0.';
    } else {
      _expression += '.';
    }
    _display = _currentToken();
  }

  void _toggleSign() {
    final token = _currentToken();
    if (token.isEmpty || token == '0') return;
    final val = double.tryParse(token);
    if (val == null) return;
    final newVal = (-val).toStringAsReduced();
    // Replace last token in expression
    final startIdx = _expression.length - token.length;
    _expression = _expression.substring(0, startIdx) + newVal;
    _display = newVal;
    _liveEval();
  }

  void _applyPercent() {
    final token = _currentToken();
    final val = double.tryParse(token);
    if (val == null) return;
    final pct = (val / 100).toStringAsReduced();
    final startIdx = _expression.length - token.length;
    _expression = _expression.substring(0, startIdx) + pct;
    _display = pct;
    _liveEval();
  }

  void _applySqrt() {
    final token = _currentToken();
    final val = double.tryParse(token);
    if (val == null) return;
    if (val < 0) {
      _result = 'Error';
      return;
    }
    final sq = math.sqrt(val).toStringAsReduced();
    final startIdx = _expression.length - token.length;
    _expression = _expression.substring(0, startIdx) + sq;
    _display = sq;
    _liveEval();
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    final evalResult = _compute(_expression);
    if (evalResult == null) {
      _result = 'Error';
      return;
    }
    _result = evalResult;
    _display = evalResult;
    _expression = evalResult;
    _justEvaluated = true;
  }

  void _liveEval() {
    if (_expression.isEmpty) {
      _result = '';
      return;
    }
    final evalResult = _compute(_expression);
    _result = evalResult ?? '';
  }

  // ── Expression Evaluator ─────────────────────────────────────────

  /// Convert display symbols to math symbols and evaluate.
  String? _compute(String expr) {
    try {
      // Replace display symbols with math equivalents
      String e = expr
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('^', '**');

      // Balance unclosed parens
      int opens = e.split('(').length - 1;
      int closes = e.split(')').length - 1;
      for (int i = 0; i < opens - closes; i++) {
        e += ')';
      }

      final result = _evalExpression(e);
      if (result == null) return null;
      if (result.isNaN || result.isInfinite) return 'Error';
      return result.toStringAsReduced();
    } catch (_) {
      return null;
    }
  }

  /// Recursive descent parser for math expressions.
  double? _evalExpression(String expr) {
    expr = expr.trim();
    if (expr.isEmpty) return null;
    return _parseAddSub(expr.split(''));
  }

  // Tokenizer + parser using Iterator<String>
  double? _parseAddSub(List<String> chars) {
    final tokens = _tokenize(chars.join());
    if (tokens == null) return null;
    return _evalTokens(tokens);
  }

  List<String>? _tokenize(String input) {
    final List<String> tokens = [];
    int i = 0;
    while (i < input.length) {
      final ch = input[i];
      if (ch == ' ') { i++; continue; }
      if (ch == '-' || ch == '+' || ch == '*' || ch == '/' || ch == '(' || ch == ')') {
        // Handle ** as power
        if (ch == '*' && i + 1 < input.length && input[i + 1] == '*') {
          tokens.add('**');
          i += 2;
          continue;
        }
        // Unary minus
        if (ch == '-' && (tokens.isEmpty || tokens.last == '(' ||
            tokens.last == '+' || tokens.last == '-' ||
            tokens.last == '*' || tokens.last == '/' || tokens.last == '**')) {
          // Collect the number
          i++;
          String num = '-';
          while (i < input.length && (RegExp(r'[0-9.]').hasMatch(input[i]))) {
            num += input[i++];
          }
          tokens.add(num);
          continue;
        }
        tokens.add(ch);
        i++;
      } else if (RegExp(r'[0-9.]').hasMatch(ch)) {
        String num = '';
        while (i < input.length && (RegExp(r'[0-9.]').hasMatch(input[i]))) {
          num += input[i++];
        }
        tokens.add(num);
      } else {
        return null; // Unknown character
      }
    }
    return tokens;
  }

  double? _evalTokens(List<String> tokens) {
    // Shunting-yard algorithm
    final List<double> values = [];
    final List<String> ops = [];

    int precedence(String op) {
      if (op == '+' || op == '-') return 1;
      if (op == '*' || op == '/') return 2;
      if (op == '**') return 3;
      return 0;
    }

    double applyOp(double a, double b, String op) {
      switch (op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/': return b == 0 ? double.nan : a / b;
        case '**': return math.pow(a, b).toDouble();
        default: return 0;
      }
    }

    for (final token in tokens) {
      if (token == '(') {
        ops.add(token);
      } else if (token == ')') {
        while (ops.isNotEmpty && ops.last != '(') {
          final b = values.removeLast();
          final a = values.removeLast();
          values.add(applyOp(a, b, ops.removeLast()));
        }
        if (ops.isNotEmpty) ops.removeLast(); // pop '('
      } else if (['+', '-', '*', '/', '**'].contains(token)) {
        while (ops.isNotEmpty && ops.last != '(' &&
            precedence(ops.last) >= precedence(token)) {
          final b = values.removeLast();
          final a = values.removeLast();
          values.add(applyOp(a, b, ops.removeLast()));
        }
        ops.add(token);
      } else {
        final val = double.tryParse(token);
        if (val == null) return null;
        values.add(val);
      }
    }

    while (ops.isNotEmpty) {
      if (values.length < 2) return null;
      final b = values.removeLast();
      final a = values.removeLast();
      values.add(applyOp(a, b, ops.removeLast()));
    }

    return values.isEmpty ? null : values.last;
  }

  // ── Utilities ────────────────────────────────────────────────────

  bool _isOperatorChar(String c) =>
      c == '+' || c == '−' || c == '×' || c == '÷' || c == '^' || c == '(';

  /// Get the last numeric token being typed.
  String _currentToken() {
    if (_expression.isEmpty) return '0';
    // Walk backwards until we hit an operator or paren
    int i = _expression.length - 1;
    while (i >= 0 && !_isOperatorChar(_expression[i]) && _expression[i] != ')') {
      i--;
    }
    final token = _expression.substring(i + 1);
    return token.isEmpty ? '0' : token;
  }
}

// ── Extension ────────────────────────────────────────────────────────
extension DoubleFormat on double {
  /// Smart formatting: strip trailing zeros, cap decimal places.
  String toStringAsReduced() {
    if (isNaN) return 'Error';
    if (isInfinite) return isNegative ? '-∞' : '∞';
    // Use int if whole number
    if (this == truncateToDouble() && abs() < 1e15) {
      return truncate().toString();
    }
    // Up to 10 significant digits
    String s = toStringAsPrecision(10);
    // Remove trailing zeros after decimal
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }
}
