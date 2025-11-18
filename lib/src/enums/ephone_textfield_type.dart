import 'package:flutter/services.dart';
import 'country.dart';
import '../formatters/phone_number_mask.dart';
import '../formatters/phone_number_digits_only_formatter.dart';
import '../formatters/phone_or_email_formatter.dart';

/// This enum is used to set the type of the [EphoneField]
enum EphoneFieldType { initial, email }

/// This extension is used to get the type of the [EphoneField]
/// based on the [EphoneFieldType] enum
extension EPhoneTextFielExtension on EphoneFieldType {
  /// Returns the keyboard type of the [EphoneField] based on the [EphoneFieldType] enum
  TextInputType get keyboardType {
    switch (this) {
      case EphoneFieldType.initial:
        return TextInputType.text;
      case EphoneFieldType.email:
        return TextInputType.emailAddress;
    }
  }

  /// Returns the input formatters of the [EphoneField] based on the [EphoneFieldType] enum
  /// Given the [Country] and the [useMask] boolean
  /// If [useMask] is true, the [PhoneNumberMaskFormatter] will be used
  /// If [useMask] is false, the [LengthLimitingTextInputFormatter] will be used
  /// In both cases, the [PhoneNumberDigistOnlyFormatter] will be used
  List<TextInputFormatter> inputFormatters(
      Country country, String? maskSplitCharacter) {
    switch (this) {
      case EphoneFieldType.initial:
        // Use a single composite formatter that preserves email-like input and
        // otherwise applies phone mask + digits-only filtering.
        return [PhoneOrEmailFormatter(country: country, maskSplitCharacter: maskSplitCharacter)];
      case EphoneFieldType.email:
        return [];
    }
  }

  /// Returns the label text of the [EphoneField] based on the [EphoneFieldType] enum
  /// Given the [emptyLabelText], [emailLabelText] and [phoneLabelText]
  String labelText(
      String emptyLabelText, String emailLabelText, String phoneLabelText) {
    switch (this) {
      case EphoneFieldType.initial:
        return emptyLabelText;
      case EphoneFieldType.email:
        return emailLabelText;
      // no phone case
    }
  }

  /// Returns the hint text of the [EphoneField] based on the [EphoneFieldType] enum
  /// Given the [validator], [Country] and [maskSplitCharacter]
  String? Function(String?)? validator(String? Function(String?)? typeValidator,
      Country country, String? maskSplitCharacter) {
    switch (this) {
      case EphoneFieldType.initial:
        return typeValidator;
      case EphoneFieldType.email:
        return typeValidator;
    }
  }

  /// Returns the hint text of the [EphoneField] based on the [Country], [maskSplitCharacter] and [onFieldSubmitted]
  void Function(String?)? onFieldSubmitted(Country country,
      String? maskSplitCharacter, void Function(String?)? onFieldSubmitted) {
    switch (this) {
      case EphoneFieldType.initial:
        return onFieldSubmitted;
      case EphoneFieldType.email:
        return onFieldSubmitted;
    }
  }

  /// Returns the hint text of the [EphoneField] based on the [Country], [maskSplitCharacter] and [onSaved]
  void Function(String?)? onSaved(Country country, String? maskSplitCharacter,
      void Function(String?)? onSaved) {
    switch (this) {
      case EphoneFieldType.initial:
        return onSaved;
      case EphoneFieldType.email:
        return onSaved;
    }
  }

  /// Returns the hint text of the [EphoneField] based on the [Country], [maskSplitCharacter] and [onChanged]
  void Function(String)? onChanged(Country country, String? maskSplitCharacter,
      void Function(String)? onChanged) {
    switch (this) {
      case EphoneFieldType.initial:
        return onChanged;
      case EphoneFieldType.email:
        return onChanged;
    }
  }
}
