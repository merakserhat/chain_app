import 'dart:io';

import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/screens/home/home_screen.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:chain_app/services/notification_service.dart';
import 'package:chain_app/utils/program.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await Hive.initFlutter();
  await LocalService().init();
  await _configureLocalTimeZone();
  NotificationService().initialize();
  Program().init();
  runApp(const MyApp());
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
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
        child: const HomeScreen(),
      ),
    );
  }
}
