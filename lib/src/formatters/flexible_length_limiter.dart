import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/services.dart';

/// A length limiter that only enforces [maxLength] when the input begins with a
/// digit. This allows replacing phone-mode input with an email address without
/// truncating the entry while still constraining numeric phone values.
class FlexibleLengthLimitingTextInputFormatter extends TextInputFormatter {
  FlexibleLengthLimitingTextInputFormatter(this.maxLength)
      : assert(maxLength == -1 || maxLength > 0,
            'maxLength must be -1 (unbounded) or greater than 0');

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow non-digit replacements (e.g., switching to an email address) to
    // bypass the length limit so the text isn't truncated before the widget
    // swaps to email mode.
    if (newValue.text.isNotEmpty && !RegExp(r'^\d').hasMatch(newValue.text)) {
      return newValue;
    }

    if (maxLength == -1 || newValue.text.characters.length <= maxLength) {
      return newValue;
    }

    final String truncated =
        newValue.text.characters.take(maxLength).toString();
    final int selectionIndex = math.min(truncated.length, newValue.selection.end);

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty,
    );
  }
}
