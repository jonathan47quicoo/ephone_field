import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ephone_field/src/formatters/phone_number_digits_only_formatter.dart';
import 'package:ephone_field/src/formatters/phone_number_mask.dart';
import 'package:ephone_field/src/enums/enums.dart';

void main() {
  test('PhoneNumberDigistOnlyFormatter allows letters after numeric start', () {
    final f = PhoneNumberDigistOnlyFormatter(maskSplitCharacter: null);
    final oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue(text: '7a');

    final result = f.formatEditUpdate(oldValue, newValue);
    expect(result.text, '7a');
  });

  test('PhoneNumberMaskFormatter skips masking when letter typed after digit', () {
    final m = PhoneNumberMaskFormatter(country: Country.unitedStates, maskSplitCharacter: ' ');
    final oldValue = TextEditingValue(text: '7');
    final newValue = TextEditingValue(text: '7a');

    final result = m.formatEditUpdate(oldValue, newValue);
    expect(result.text, '7a');
  });
}

