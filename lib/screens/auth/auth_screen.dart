import 'package:chain_app/screens/auth/widgets/login_form.dart';
import 'package:chain_app/screens/auth/widgets/register_form.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isRegister = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: ((Theme.of(context).brightness == Brightness.dark)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
          statusBarColor: Theme.of(context).colorScheme.background,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.fromLTRB(
                                      138, 30, 138, 0),
                                  child: Image.asset("assets/images/logo.png")),
                              Text(
                                "App Title",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                          isRegister
                              ? RegisterFormWidget(changeAuth: changeAuthType)
                              : LoginFormWidget(changeAuth: changeAuthType),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeAuthType() {
    setState(() {
      isRegister = !isRegister;
    });
  }
}
