import 'package:weather_app/utils/strings.dart';

class ValidationHelper {
  static RegExp patternName = RegExp(r'.{1,}$');
  static RegExp patternMobileNumber = RegExp(r'^[0-9]{10,10}$');
  static RegExp patternPassword = RegExp(r'.{6,}$');
  static RegExp patternGroupCode = RegExp(r'.{6}$');
  static RegExp patternListToString = RegExp(r'\[|\]');
  static RegExp patternEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp patternDoubleNumber = RegExp(r'^[0-9]+.?[0-9]*');

  /// Name validation
  static String? validateName(String? value, {String? errorText}) {
    String? result;
    if (value!.isEmpty) {
      result = "${AppStrings.enter} ${errorText ?? AppStrings.fullName}";
    } else if (!patternName.hasMatch(value)) {
      result =
          "${AppStrings.enter} ${AppStrings.valid} ${errorText ?? AppStrings.fullName}";
    }
    return result;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    String? result;
    if (value!.isEmpty) {
      result = AppStrings.passwordCantBeEmpty;
    } else if (!patternPassword.hasMatch(value)) {
      result = AppStrings.passwordMustBe;
    }
    return result;
  }

  /// Password validation
  static String? validateReEnterPassword(String? value, String? password) {
    String? result;
    if (value!.isEmpty) {
      result = AppStrings.passwordCantBeEmpty;
    } else if (value != password) {
      result = AppStrings.passwordDoesntMatch;
    }
    return result;
  }

  /// email validation
  static String? validateEmail(String? value) {
    String? result;

    if (value!.isEmpty) {
      result = "${AppStrings.enter} ${AppStrings.email}";
    } else if (patternEmail.hasMatch(value) == false) {
      result = "${AppStrings.enter} ${AppStrings.valid} ${AppStrings.email}";
    }
    return result;
  }
}
