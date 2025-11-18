import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ephone_field/ephone_field.dart';
import 'package:ephone_field/src/components/country_picker_button.dart';

void main() {
  testWidgets('country picker shows for digits-only and hides when letter entered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EPhoneField(),
          ),
        ),
      ),
    );

    // Type a digit first.
    await tester.enterText(find.byType(TextFormField), '7');
    await tester.pumpAndSettle();

    // CountryPickerButton should be present for digit-only input.
    expect(find.byType(CountryPickerButton), findsOneWidget);

    // Now type a letter after the digit.
    await tester.enterText(find.byType(TextFormField), '7a');
    await tester.pumpAndSettle();

    // The country picker should be gone when a letter is detected.
    expect(find.byType(CountryPickerButton), findsNothing);
  });
}
