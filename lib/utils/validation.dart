import 'package:keep_it_g/localization/keys.dart';
import 'package:keep_it_g/localization/translations.i18n.dart';

///r'^
///   (?=.*[A-Z])       // should contain at least one upper case
///   (?=.*[a-z])       // should contain at least one lower case
///   (?=.*?[0-9])      // should contain at least one digit
///   (?=.*?[!@#\$&*~]) // should contain at least one Special character
///   .{8,}             // Must be at least 8 characters in length
/// $

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(this);
  }

  bool isContainUpperCase() {
    return RegExp(r'^(?=.*?[A-Z])$').hasMatch(this);
  }

  bool isContainLowerCase() {
    return RegExp(r'^(?=.*?[a-z])$').hasMatch(this);
  }

  bool isContainDigit() {
    return RegExp(r'^(?=.*?[0-9])$').hasMatch(this);
  }

  bool isContainSpecialChar() {
    return RegExp(r'^(?=.*?[!@#\$&*~])$').hasMatch(this);
  }

  bool isMinEightChar() {
    return RegExp(r'^.{8,}$').hasMatch(this);
  }
}

class Validator {
  static String? onEmailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return TranslationKeys.warnEnterText.i18n;
    }
    if (!value.isValidEmail()) {
      return TranslationKeys.warnEnterEmail.i18n;
    }
    return null;
  }

  static String? onNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return TranslationKeys.warnEnterText.i18n;
    }
    if (value.isContainDigit()) {
      return TranslationKeys.warnEnterEmail.i18n;
    }
    return null;
  }

  static String? onNotEmptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return TranslationKeys.warnEnterText.i18n;
    }
    return null;
  }

  static String? onPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return TranslationKeys.warnEnterText.i18n;
    }
    // if (!value.isContainUpperCase()) {
    //   return TranslationKeys.warnValidationUpperCase;
    // }
    // if (!value.isContainLowerCase()) {
    //   return TranslationKeys.warnValidationLowerCase;
    // }
    // if (!value.isContainDigit()) {
    //   return TranslationKeys.warnValidationDigit;
    // }
    // if (!value.isContainSpecialChar()) {
    //   return TranslationKeys.warnValidationSpecialChar;
    // }
    // if (!value.isMinEightChar()) {
    //   return TranslationKeys.warnValidationLength;
    // }
    return null;
  }
}
