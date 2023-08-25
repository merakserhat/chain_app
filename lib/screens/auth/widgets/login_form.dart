import 'package:chain_app/models/helper/auth_validation_errors.dart';
import 'package:chain_app/models/response/login_response.dart';
import 'package:chain_app/models/response/register_response.dart';
import 'package:chain_app/screens/auth/widgets/auth_input.dart';
import 'package:chain_app/services/mock_auth.dart';
import 'package:chain_app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/app_button.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key, required this.changeAuth}) : super(key: key);

  final VoidCallback changeAuth;

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  AuthValidationErrors authValidationErrors = AuthValidationErrors();
  LoginResponse loginResponse = LoginResponse();

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
                    textController: emailController,
                    validationError: authValidationErrors.email,
                    serverError: loginResponse.emailError,
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
                    serverError: loginResponse.passwordError,
                    isPass: true,
                    text: "Password")),
            const SizedBox(
              height: 24,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : AppButton(
                    label: "Login",
                    onPressed: loginHandler,
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
                    "Don't you have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    "Register",
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

  loginHandler() async {
    setState(() {
      authValidationErrors = Validator().validateLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    });

    if (authValidationErrors.valid) {
      setState(() {
        isLoading = true;
      });
      loginResponse = await MockAuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (loginResponse.isValid) {
        print("Logged in");
        // TODO: switch to login or go to home screen

      }
    }
  }
}
