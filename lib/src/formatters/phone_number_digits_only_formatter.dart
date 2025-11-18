import 'package:flutter/services.dart';

class PhoneNumberDigistOnlyFormatter extends TextInputFormatter {
  final String? maskSplitCharacter;

  PhoneNumberDigistOnlyFormatter({required this.maskSplitCharacter});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value clearly looks like an email/username (contains letters
    // or typical email characters), allow it through so the user can type
    // letters after starting with digits (e.g., "123abc@example.com").
    final RegExp emailLike = RegExp(r'[A-Za-z@._\-+]');
    if (newValue.text.isNotEmpty && newValue.text.contains(emailLike)) {
      // If old had no email-like chars and new does, this is likely the user
      // typing the first alphabetic/punctuation char (e.g., '7' -> '7a').
      if (!oldValue.text.contains(emailLike)) {
        return newValue;
      }

      // If old already had email-like chars, allow the change.
      return newValue;
    }

    // Also detect a simple insertion where the length increased and the newly
    // inserted substring contains an email-like character.
    if (newValue.text.length > oldValue.text.length) {
      final int start = 0; // conservative: look for difference suffix/prefix
      // Find the first index where they differ.
      int diffIndex = 0;
      while (diffIndex < oldValue.text.length && diffIndex < newValue.text.length &&
          oldValue.text[diffIndex] == newValue.text[diffIndex]) {
        diffIndex++;
      }
      final String inserted = newValue.text.substring(diffIndex);
      if (inserted.contains(emailLike) && !oldValue.text.contains(emailLike)) {
        return newValue;
      }
    }

    // Otherwise strip all characters except digits and the optional mask splitter
    // so phone-entry behavior still works when the input is purely numeric.
    final String newText = newValue.text.replaceAll(RegExp('[^0-9${maskSplitCharacter ?? ''}]'), '');
    final int selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
