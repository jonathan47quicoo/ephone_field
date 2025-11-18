import 'package:flutter/services.dart';

import '../enums/enums.dart';
import 'phone_number_mask.dart';
import 'phone_number_digits_only_formatter.dart';

/// A composite formatter that behaves like a phone formatter for numeric input
/// but allows email-like characters when detected (so typing letters after a
/// leading digit is preserved).
class PhoneOrEmailFormatter extends TextInputFormatter {
  final Country country;
  final String? maskSplitCharacter;

  PhoneOrEmailFormatter({required this.country, required this.maskSplitCharacter});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp emailLike = RegExp(r'[A-Za-z@._\-+]');

    // If the new text contains any email-like character, allow it through
    // unchanged so the user can type an email that starts with digits.
    if (newValue.text.isNotEmpty && newValue.text.contains(emailLike)) {
      return newValue;
    }

    TextEditingValue intermediate = newValue;

    // Apply mask first (if configured), then digits-only filtering.
    if (maskSplitCharacter != null && maskSplitCharacter!.isNotEmpty) {
      final maskFormatter = PhoneNumberMaskFormatter(country: country, maskSplitCharacter: maskSplitCharacter);
      intermediate = maskFormatter.formatEditUpdate(oldValue, intermediate);
    }

    final digitsFormatter = PhoneNumberDigistOnlyFormatter(maskSplitCharacter: maskSplitCharacter);
    final result = digitsFormatter.formatEditUpdate(oldValue, intermediate);

    return result;
  }
}

