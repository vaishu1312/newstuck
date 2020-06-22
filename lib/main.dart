import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newstuck/clement_activities/home.dart';
import 'package:newstuck/vaishali/dashboard.dart';
import 'package:get/get.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //   runApp(GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Home(),
  //   ));
  // });
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));
}
