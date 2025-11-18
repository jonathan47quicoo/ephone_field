import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/country_picker_button.dart';
import 'enums/country.dart';
import 'enums/country_picker_height.dart';
import 'enums/country_picker_menu.dart';
import 'enums/ephone_textfield_type.dart';

class EPhoneField extends StatefulWidget {
  const EPhoneField({
    Key? key,
    this.controller,
    this.focusNode,
    this.initialType = EphoneFieldType.initial,
    this.countries = Country.values,
    this.searchInputDecoration = const InputDecoration(
      hintText: 'Search your country',
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.search),
    ),
    this.isSearchable = true,
    this.title,
    this.titlePadding = const EdgeInsets.all(8.0),
    this.pickerHeight = CountryPickerHeigth.h50,
    this.menuType = PickerMenuType.bottomSheet,
    this.initialCountry = Country.unitedStates,
    this.onChanged,
    this.onCountryChanged,
    this.initialValue,
    this.emptyLabelText = 'Email or phone number',
    this.emailLabelText = 'Email',
    this.phoneLabelText = 'Phone number',
    this.onSaved,
    this.onFieldSubmitted,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Email or phone number',
    ),
    this.countryPickerButtonIcon = Icons.arrow_drop_down,
    this.phoneNumberMaskSplitter,
    this.inputFormatters,
    this.emailValidator,
    this.phoneValidator,
    this.emptyErrorText,
    this.countryPickerButtonWidth = 108.0,
    this.autovalidateMode,
    this.keyboardTypeOverride,
    this.loseFocusAfterOneChar = false,
  }) : super(key: key);

  /// Optional override for the keyboard type used by the text field.
  /// If null, the widget will request an alphanumeric keyboard ([TextInputType.text])
  /// so the user can enter email or phone characters without forcing a numeric keypad.
  final TextInputType? keyboardTypeOverride;

  /// The [FocusNode] of the input field.
  final FocusNode? focusNode;

  /// If true, the field will lose focus automatically after the user types the
  /// first character (i.e. when content goes from length 0 -> 1). Defaults to
  /// `false` (the field will not unfocus after the first character by default).
  final bool loseFocusAfterOneChar;

  /// The [TextEditingController] of the input field.
  final TextEditingController? controller;

  /// The [List<Country>] to be used in the country picker. Defaults to [Country.values].
  final List<Country> countries;

  /// The [Country] to be selected when the widget is initialized. Defaults to [Country.unitedStates].
  final Country initialCountry;

  /// The [EphoneFieldType] to be selected when the widget is initialized. Defaults to [EphoneFieldType.initial].
  final EphoneFieldType initialType;

  /// The [String] to be used as the initial value of the input field.
  final String? initialValue;

  /// The [String] to be used as the title of the country picker menu.
  final String? title;

  /// The [EdgeInsetsGeometry] to be used as padding of the title of the country picker menu. Defaults to [EdgeInsets.all(8.0)].
  final EdgeInsetsGeometry titlePadding;

  /// The [PickerMenuType] to be used as the type of the country picker menu. Defaults to [PickerMenuType.bottomSheet].
  final PickerMenuType menuType;

  /// The [InputDecoration] to be used as the decoration of the search field of the country picker menu. Defaults to:
  /// ```
  /// InputDecoration(
  ///  hintText: 'Search your country',
  /// border: OutlineInputBorder(),
  /// suffixIcon: Icon(Icons.search),
  /// )
  /// ```
  final InputDecoration searchInputDecoration;

  /// The [CountryPickerHeigth] to be used as the height of the country picker menu. Defaults to [CountryPickerHeigth.h50].
  /// The [CountryPickerHeigth] is not effective when the [menuType] is [PickerMenuType.page].
  final CountryPickerHeigth pickerHeight;

  /// The [bool] to be used as the searchable property of the country picker menu to visible or hide the search field. Defaults to [true].
  final bool isSearchable;

  /// The [String] to be used as the empty label text of the input field. Defaults to 'Email or phone number'.
  final String emptyLabelText;

  /// The [String] to be used as the email label text of the input field. Defaults to 'Email'.
  final String emailLabelText;

  /// The [String] to be used as the phone label text of the input field. Defaults to 'Phone number'.
  final String phoneLabelText;

  /// The [ValueChanged<Country>] to be used as the callback when the country is changed.
  final ValueChanged<Country>? onCountryChanged;

  /// The [ValueChanged<String>] to be used as the callback when the value of the input field is changed.
  final void Function(String)? onChanged;

  /// The [ValueChanged<String>] to be used as the callback when the value of the input field is saved.
  final void Function(String?)? onSaved;

  /// The [ValueChanged<String>] to be used as the callback when the value of the input field is submitted.
  final void Function(String?)? onFieldSubmitted;

  /// The [String? Function(String?)] to be used as the email validator of the input field.
  /// The callback should return null if the input is valid, otherwise a String with an error message.
  /// The [String] value passed to the callback is the email address.
  final String? Function(String?)? emailValidator;

  /// The [String? Function(String?)] to be used as the phone validator of the input field.
  /// The callback should return null if the input is valid, otherwise a String with an error message.
  /// The [String] value passed to the callback is the phone number with the country dial code (e.g. +441234567890).
  final String? Function(String?)? phoneValidator;

  /// The [String? Function(String?)] to be used as the empty validator of the input field.
  /// The callback should return null if the input is valid, otherwise a String with an error message.
  final String? emptyErrorText;

  /// The [InputDecoration] to be used as the decoration of the input field. Defaults to:
  /// ```
  /// InputDecoration(
  /// border: OutlineInputBorder(),
  /// hintText: 'Phone number or email',
  /// )
  /// ```
  /// The [prefixIcon] of the input field is replaced by the country picker button when the [EphoneFieldType] is [EphoneFieldType.phone].
  /// The [labelText] of the input field is replaced by the [EphoneFieldType] label text when the [EphoneFieldType] is [EphoneFieldType.phone] or [EphoneFieldType.email].
  /// The [labelText] of the input field is replaced by the [emptyLabelText] when the [EphoneFieldType] is [EphoneFieldType.initial].
  /// The [labelText] of the input field is replaced by the [emailLabelText] when the [EphoneFieldType] is [EphoneFieldType.email].
  /// The [labelText] of the input field is replaced by the [phoneLabelText] when the [EphoneFieldType] is [EphoneFieldType.phone].
  final InputDecoration decoration;

  /// The [IconData] to be used as the icon of the country picker button. Defaults to [Icons.arrow_drop_down
  final IconData countryPickerButtonIcon;

  /// The [MaskSplitCharacter] to be used as the mask splitter of the phone number input field. Defaults to [MaskSplitCharacter.space].
  /// The [MaskSplitCharacter] is only used when the [EphoneFieldType] is [EphoneFieldType.phone].
  /// If the [MaskSplitCharacter] is [MaskSplitCharacter.none], the [PhoneNumberMaskFormatter] is not used.
  /// If the [MaskSplitCharacter] is [MaskSplitCharacter.space], the [PhoneNumberMaskFormatter] is used with the space character as the mask splitter.
  /// If the [MaskSplitCharacter] is [MaskSplitCharacter.dash], the [PhoneNumberMaskFormatter] is used with the dash character as the mask splitter.
  final String? phoneNumberMaskSplitter;

  /// The [List<TextInputFormatter>] to be used as the input formatters of the input field.
  /// As default, the [PhoneNumberMaskFormatter] and [PhoneNumberDigistOnlyFormatter] are used when the [EphoneFieldType] is [EphoneFieldType.phone].
  /// If the [phoneNumberMaskSplitter] is [MaskSplitCharacter.none], the [PhoneNumberMaskFormatter] is not used.
  /// If don't want to use the [PhoneNumberMaskFormatter], you can pass an empty list to the [inputFormatters].
  final List<TextInputFormatter>? inputFormatters;

  /// The [double] to be used as the width of the country picker button. Defaults to 100.0.
  final double countryPickerButtonWidth;

  /// The [AutovalidateMode] to be used as the autovalidate mode of the input field. Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  @override
  State<EPhoneField> createState() => _EphoneFieldState();
}

class _EphoneFieldState extends State<EPhoneField> {
  late EphoneFieldType _type;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Country _selectedCountry;
  late bool _ownsController;
  late bool _ownsFocusNode;
  // Tracks the previous text length so we can detect a 0 -> 1 transition.
  int _prevTextLength = 0;
  // Key for the internal TextFormField so we can trigger validation when
  // external things change (like the selected country).
  final GlobalKey<FormFieldState<String>> _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _selectedCountry = widget.initialCountry;
    _controller = widget.controller ?? TextEditingController();
    _ownsController = widget.controller == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _controller.addListener(() {
      final currentText = _controller.text;
      final currentLength = currentText.length;

      _updateTextFieldType();

      // If requested, lose focus when the user types the first character
      // (transition from length 0 -> 1).
      if (widget.loseFocusAfterOneChar) {
        if (_prevTextLength == 0 && currentLength == 1 && _focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      }

      _prevTextLength = currentLength;
    });
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldKey,
      // Use the caller override if provided; otherwise use the keyboard type
      // for the current field type so switching to email mode uses an
      // email-optimized keyboard layout.
      keyboardType: widget.keyboardTypeOverride ?? _type.keyboardType,
      controller: _controller,
      focusNode: _focusNode,
      autovalidateMode: widget.autovalidateMode,
      onChanged: _type.onChanged(
          _selectedCountry, widget.phoneNumberMaskSplitter, widget.onChanged),
      onSaved: _type.onSaved(
          _selectedCountry, widget.phoneNumberMaskSplitter, widget.onSaved),
      onFieldSubmitted: _type.onFieldSubmitted(
        _selectedCountry,
        widget.phoneNumberMaskSplitter,
        widget.onFieldSubmitted,
      ),
      // initialValue: widget.initialValue,
      decoration: widget.decoration.copyWith(
          // Hide the country picker when the field is in email mode.
          prefixIcon: _type == EphoneFieldType.email || _type == EphoneFieldType.initial? null : _buildCountryPicker(),
          labelText: _type.labelText(widget.emptyLabelText, widget.emailLabelText, widget.phoneLabelText)),
      validator: _type.validator(_selectedValidatorForType(), _selectedCountry, null),
      // Make sure the phone/email-aware formatter receives the configured
      // mask splitter so switching to email updates formatters correctly.
      inputFormatters: widget.inputFormatters ?? _type.inputFormatters(_selectedCountry, widget.phoneNumberMaskSplitter),
    );
  }

  /// Builds the [CountryPickerButton].
  /// Note: country picker is retained but not tied to a "phone" mode.
  Widget? _buildCountryPicker() {
    return CountryPickerButton(
      initialValue: _selectedCountry,
      onValuePicked: (Country country) {
        setState(() {
          _selectedCountry = country;
          widget.onCountryChanged?.call(country);
          // Re-run validation for the field whenever the country changes so
          // validators that depend on the selected country get evaluated.
          _fieldKey.currentState?.validate();
          _focusNode.requestFocus();
        });
      },
      menuType: widget.menuType,
      isSearchable: widget.isSearchable,
      searchInputDecoration: widget.searchInputDecoration,
      titlePadding: widget.titlePadding,
      title: widget.title,
      countries: widget.countries,
      width: widget.countryPickerButtonWidth,
      icon: widget.countryPickerButtonIcon,
      pickerHeight: widget.pickerHeight,
    );
  }

  /// Updates the [_type] of the input field based on the [_controller] text.
  void _updateTextFieldType() {
    // Behavior: if the field contains any alphabetic character or email-like
    // symbol (such as @ . _ - +) we treat it as an email field. Empty text
    // falls back to the initialType.
    final String text = _controller.text;

    if (text.isEmpty) {
      final EphoneFieldType newType = widget.initialType;
      if (newType != _type) {
        setState(() {
          _type = newType;
        });
      }
      return;
    }

    // Explicit checks: letters OR email symbols trigger email mode. Digits alone do not.
    final bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(text);
    final bool hasEmailSymbol = RegExp(r'[@._\-+]').hasMatch(text);

    final bool shouldBeEmail = hasLetter || hasEmailSymbol;

    final EphoneFieldType newType = shouldBeEmail ? EphoneFieldType.email : EphoneFieldType.initial;

    if (newType != _type) {
      setState(() {
        _type = newType;
      });
    }
  }

  String? Function(String?)? _selectedValidatorForType() {
    switch (_type) {
      case EphoneFieldType.initial:
        return widget.emptyErrorText == null
            ? null
            : (value) => value == null || value.isEmpty ? widget.emptyErrorText : null;
      case EphoneFieldType.email:
        // Use any provided emailValidator directly. Emails starting with digits
        // are allowed (e.g., "123user@example.com").
        return widget.emailValidator;
    }
  }
}
