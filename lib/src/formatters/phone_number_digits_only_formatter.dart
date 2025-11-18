import 'package:flutter/services.dart';

class PhoneNumberDigistOnlyFormatter extends TextInputFormatter {
  final String? maskSplitCharacter;

  PhoneNumberDigistOnlyFormatter({required this.maskSplitCharacter});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value clearly looks like an email/username (contains letters
    // or typical email characters), allow it through so the user can type
    // letters after starting with digits (e.g., "123abc@example.com").
    if (newValue.text.isNotEmpty && newValue.text.contains(RegExp(r'[A-Za-z@._\-+]'))) {
      return newValue;
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
