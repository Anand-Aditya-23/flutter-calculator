/// Utility functions for display formatting.
library;

/// Adds thousand separators to a number string for readability.
/// e.g. "1234567" → "1,234,567"
String formatDisplayNumber(String raw) {
  if (raw.isEmpty || raw == 'Error' || raw == '∞' || raw == '-∞') return raw;

  // Split on decimal
  final parts = raw.split('.');
  final intPart = parts[0];
  final decPart = parts.length > 1 ? '.${parts[1]}' : '';

  // Add commas to integer part (handle negative)
  final isNeg = intPart.startsWith('-');
  final digits = isNeg ? intPart.substring(1) : intPart;

  final buf = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }

  return '${isNeg ? '-' : ''}$buf$decPart';
}

/// Returns true if [s] is a valid partial expression (can still be typed into).
bool isPartialExpression(String s) {
  // Ends with operator = partial
  return RegExp(r'[\+\−\×\÷\^\(]$').hasMatch(s);
}
