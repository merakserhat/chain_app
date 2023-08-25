import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/auth/auth_screen.dart';
import 'package:chain_app/screens/home/home_screen.dart';
import 'package:chain_app/screens/splash/splash_screen.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void handleAuth() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (_) => const AuthScreen()));
  }

  void handleSplash() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (_) => const SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
    // return Scaffold(
    //   backgroundColor: AppColors.dark700,
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //         AppButton(
    //           label: "Splash",
    //           onPressed: handleSplash,
    //         ),
    //         AppButton(
    //           label: "Auth",
    //           onPressed: handleAuth,
    //         ),
    //       ],
    //     ),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
