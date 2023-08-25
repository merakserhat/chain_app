import 'dart:ui';
import 'package:chain_app/constants/app_constants.dart';
import 'package:chain_app/screens/auth/auth_screen.dart';
import 'package:chain_app/services/app_client.dart';
import 'package:chain_app/services/mock_auth.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //means at least show this screen 2 seconds when app is opening
  late bool tokenValidated = false;
  bool minDurationPassed = false;

  // TODO remove
  String page = "Splash";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initializeAuthentication());
    Future.delayed(Duration(seconds: 1), () {
      if (tokenValidated) {
        // TODO: change page here
        setState(() {
          page = "Home";
        });
        return;
      }

      minDurationPassed = true;
    });
  }

  void initializeAuthentication() {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString(AppConstants.tokenKey);

      print(token);

      if (token == null || token.isEmpty) {
        return;
      }

      MockAuthService.validateToken(token: token).then(
        (validated) {
          print(validated);

          if (validated) {
            AppClient().token = token;
            if (minDurationPassed) {
              // TODO: change here
              setState(() {
                page = "Home";
              });
              return;
            }

            setState(() {
              tokenValidated = true;
            });
          }
        },
      ).catchError((error) {});
    }).catchError(
      (error) {
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(page),
              AppButton(
                  label: "Login",
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (_) => AuthScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
