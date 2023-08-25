class AuthValidationErrors {
  bool valid;
  String? email;
  String? password;
  String? username;
  String? agreement;

  AuthValidationErrors({
    this.valid = true,
    this.email,
    this.username,
    this.password,
    this.agreement,
  });
}
