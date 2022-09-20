class Validator {
  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please, enter your e-mail';
    }
    RegExp regexp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regexp.hasMatch(value)) {
      return 'Please, enter a VALID e-mail';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please, enter your password';
    }
    RegExp regexp = RegExp(r"^.{6,}$");
    if (!regexp.hasMatch(value)) {
      return 'Password should contain at least 6 characters';
    }
    return null;
  }
}
