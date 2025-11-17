import 'package:flutter/services.dart';

class PhoneNumberDigistOnlyFormatter extends TextInputFormatter {
  final String? maskSplitCharacter;

  PhoneNumberDigistOnlyFormatter({required this.maskSplitCharacter});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value no longer starts with a digit (e.g., the user replaced a
    // numeric phone entry with an email), allow the text through so the field
    // can switch back to email mode.
    if (newValue.text.isNotEmpty && !RegExp(r'^\d').hasMatch(newValue.text)) {
      return newValue;
    }

    // Remove all non-digits characters without mask split character from the input string
    final String newText = newValue.text.replaceAll(RegExp('[^0-9$maskSplitCharacter]'), '');
    final int selectionIndex = newText.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
