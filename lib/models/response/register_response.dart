class RegisterResponse {
  late bool isValid;
  String? passwordError;
  String? emailError;
  String? serverError;
  String? usernameError;
  String? token;

  RegisterResponse({
    this.isValid = true,
    this.passwordError,
    this.emailError,
    this.serverError,
    this.usernameError,
    this.token,
  });

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    isValid = json["status"] == "success";
    if (json["error"] != null) {
      passwordError = json['error']["password"];
      emailError = json['error']["email"];
      usernameError = json['error']["username"];
    }

    token = json["token"];

    // if error is not based on password and email
    if (!isValid &&
        passwordError == null &&
        emailError == null &&
        usernameError == null) {
      serverError = "Something went wrong";
    }
  }
}
