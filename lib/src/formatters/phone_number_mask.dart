import 'package:flutter/services.dart';

import '../enums/enums.dart';

class PhoneNumberMaskFormatter extends TextInputFormatter {
  final Country country;
  final String? maskSplitCharacter;

  PhoneNumberMaskFormatter({required this.country, required this.maskSplitCharacter});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      final RegExp emailLike = RegExp(r'[A-Za-z@._\-+]');
      final bool startsWithDigit = RegExp(r'^\d').hasMatch(newValue.text);
      final bool containsEmailLike = newValue.text.contains(emailLike);
      final bool oldHadEmailLike = oldValue.text.contains(emailLike);

      // If the text clearly isn't a phone, or contains email-like characters,
      // or the user just typed the first email-like char (difference insertion),
      // allow it through unchanged.
      if (!startsWithDigit || containsEmailLike || (!oldHadEmailLike && containsEmailLike)) {
        return newValue;
      }

      // Also detect a simple insertion where the length increased and the newly
      // inserted substring contains an email-like character (handles '7' -> '7a').
      if (newValue.text.length > oldValue.text.length) {
        int diffIndex = 0;
        while (diffIndex < oldValue.text.length && diffIndex < newValue.text.length &&
            oldValue.text[diffIndex] == newValue.text[diffIndex]) {
          diffIndex++;
        }
        final String inserted = newValue.text.substring(diffIndex);
        if (inserted.contains(emailLike) && !oldHadEmailLike) {
          return newValue;
        }
      }
    }

    final String mask = country.mask;
    final String maskCharacter = country.mask[0];
    String text = newValue.text;
    String oldText = oldValue.text;
    if (maskSplitCharacter != null) {
      text = text.replaceAll(maskSplitCharacter!, '');
      oldText = oldText.replaceAll(maskSplitCharacter!, '');
    }
    final String newText = _applyMask(mask, maskCharacter, maskSplitCharacter, text, oldText);
    final int selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _applyMask(
    String mask,
    String maskCharacter,
    String? maskSplitCharacter,
    String text,
    String oldText,
  ) {
    if (maskSplitCharacter == null) return text;
    final StringBuffer newText = StringBuffer();

    int textIndex = 0;

    for (int i = 0; i < mask.length; i++) {
      if (textIndex >= text.length) {
        break;
      }

      if (mask[i] == maskCharacter) {
        newText.write(text[textIndex]);
        textIndex++;
      } else {
        newText.write(maskSplitCharacter);
      }
    }

    if (oldText.length > text.length && newText.toString().endsWith(maskSplitCharacter)) {
      newText.write(oldText[oldText.length - 1]);
    }

    return newText.toString();
  }
}
