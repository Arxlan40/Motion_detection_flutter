import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:clycou/splash.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io';
import 'Test.dart';
import 'home.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
 Wakelock.enable();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motion App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
