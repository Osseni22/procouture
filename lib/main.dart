import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/screens/confection/client/client_save_page.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/screens/home/splash_screen.dart';
import 'package:procouture/utils/globals/global_var.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Rendre la Status Bar transparente
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  /// Récupérer le nom du telephone
  if(Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Globals.deviceName = androidInfo.model;
  } else if(Platform.isIOS){
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    Globals.deviceName = iosInfo.utsname.machine!;
  } else {
    Globals.deviceName = 'unknown';
  }

  // Forcer le mode Portrait au lancement
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProCouture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}


