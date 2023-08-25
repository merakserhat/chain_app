import 'package:chain_app/models/helper/auth_validation_errors.dart';
import 'package:chain_app/models/response/register_response.dart';
import 'package:chain_app/screens/auth/widgets/auth_input.dart';
import 'package:chain_app/services/mock_auth.dart';
import 'package:chain_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({Key? key, required this.changeAuth})
      : super(key: key);

  final VoidCallback changeAuth;

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;

  AuthValidationErrors authValidationErrors = AuthValidationErrors();
  RegisterResponse registerResponse = RegisterResponse();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          children: [
            const SizedBox(
              height: 38,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: AuthInput(
                    textController: usernameController,
                    validationError: authValidationErrors.username,
                    serverError: registerResponse.usernameError,
                    text: "Username")),
            const SizedBox(
              height: 30,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: AuthInput(
                    textController: emailController,
                    validationError: authValidationErrors.email,
                    serverError: registerResponse.emailError,
                    text: "E-mail")),
            //const SizedBox(width: 22),
            const SizedBox(
              height: 30,
            ),

            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: AuthInput(
                    textController: passwordController,
                    validationError: authValidationErrors.password,
                    serverError: registerResponse.passwordError,
                    isPass: true,
                    text: "Password")),
            const SizedBox(
              height: 24,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : AppButton(
                    label: "Register",
                    onPressed: registerHandler,
                  ),
            const SizedBox(height: 72),
            InkWell(
              onTap: () {
                widget.changeAuth();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  registerHandler() async {
    setState(() {
      authValidationErrors = Validator().validateRegister(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          username: usernameController.text.trim());
    });

    if (authValidationErrors.valid) {
      setState(() {
        isLoading = true;
      });
      registerResponse = await MockAuthService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        username: usernameController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (registerResponse.isValid) {
        print("Kaydoldun");
        // TODO: switch to login or go to home screen
      }
    }
  }
}
