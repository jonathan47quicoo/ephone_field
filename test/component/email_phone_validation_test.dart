import 'package:ephone_field/src/email_phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlobalKey<FormState> formKey;
  late TextEditingController controller;

  String? _formatStrictEmailValidator(String? value) {
    final String email = value ?? '';
    final RegExp format =
        RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    if (!format.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  setUp(() {
    formKey = GlobalKey<FormState>();
    controller = TextEditingController();
  });

  Widget _buildField({
    String? Function(String?)? emailValidator,
    String? Function(String?)? phoneValidator,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: EPhoneField(
            controller: controller,
            emptyErrorText: 'Field cannot be empty',
            emailValidator: emailValidator ?? _formatStrictEmailValidator,
            phoneValidator: phoneValidator ??
                (value) => value == null || value.isEmpty
                    ? 'Phone number required'
                    : null,
          ),
        ),
      ),
    );
  }

  testWidgets('fails validation when email format is incorrect',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField());

    await tester.enterText(find.byType(EPhoneField), 'invalid-email');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('displays error when email starts with a number',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField(emailValidator: (value) {
      // Accepts any email-looking value so we can verify the built-in
      // leading-digit check coming from _updateSelectedValidator.
      if (value != null && value.contains('@')) return null;
      return 'Email missing @';
    }));

    await tester.enterText(find.byType(EPhoneField), '1user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Email must not start with a number'), findsOneWidget);
  });

  testWidgets('keeps phone input numeric after starting with a digit',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField());

    await tester.enterText(find.byType(EPhoneField), '1a2b3c');
    await tester.pump();

    expect(controller.text, '123');
    expect(find.text('Phone number'), findsOneWidget);
  });

  testWidgets('can return to email mode after phone-like input',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField());

    await tester.enterText(find.byType(EPhoneField), '123456');
    await tester.pump();

    expect(find.text('Phone number'), findsOneWidget);

    await tester.enterText(find.byType(EPhoneField), 'user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsNothing);
  });

  testWidgets(
      'shows an error when a numeric prefix is added to an existing email',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField());

    await tester.enterText(find.byType(EPhoneField), 'user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsNothing);

    await tester.enterText(find.byType(EPhoneField), '1user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Email must not start with a number'), findsOneWidget);
  });

  testWidgets('clears leading-digit email error after correction',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildField());

    await tester.enterText(find.byType(EPhoneField), '1user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Email must not start with a number'), findsOneWidget);

    await tester.enterText(find.byType(EPhoneField), 'user@example.com');
    await tester.pump();

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Email must not start with a number'), findsNothing);
    expect(find.text('Enter a valid email address'), findsNothing);
  });
}
