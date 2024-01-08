import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/auth/auth_screen.dart';
import 'package:chain_app/screens/home/home_screen.dart';
import 'package:chain_app/screens/splash/splash_screen.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:chain_app/utils/program.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await LocalService().init();
  Program().init();
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
      color: Colors.red,
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider.value(
        value: Program(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
    return const HomeScreen();
  }
}
