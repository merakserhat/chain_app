import 'package:chain_app/models/helper/auth_validation_errors.dart';

class Validator {
  static String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E-mail address is required.';
    }

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

    return null;
  }

  static String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty)
      return 'Password is required.';

    if (formPassword.length < 6)
      return 'Password must be at least 6 characters.';

    return null;
  }

  static String? validateUsername(String? formUsername) {
    if (formUsername == null || formUsername.isEmpty) {
      return 'Username is required.';
    }

    if (formUsername.length < 3)
      return 'Username must be at least 3 characters.';

    return null;
  }

  AuthValidationErrors validateRegister({
    String? email,
    String? password,
    String? username,
  }) {
    AuthValidationErrors authValidationErrors = AuthValidationErrors();
    authValidationErrors.email = validateEmail(email);
    authValidationErrors.password = validatePassword(password);
    authValidationErrors.username = validateUsername(username);

    authValidationErrors.valid = authValidationErrors.email == null &&
        authValidationErrors.password == null &&
        authValidationErrors.username == null;

    return authValidationErrors;
  }

  AuthValidationErrors validateLogin({
    String? email,
    String? password,
  }) {
    AuthValidationErrors authValidationErrors = AuthValidationErrors();
    authValidationErrors.email = validateEmail(email);
    authValidationErrors.password = validatePassword(password);

    authValidationErrors.valid = authValidationErrors.email == null &&
        authValidationErrors.password == null &&
        authValidationErrors.username == null;

    return authValidationErrors;
  }
}
