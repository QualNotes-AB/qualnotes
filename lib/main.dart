import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAp8g5hrKqDQGwLhQCc3M1SWSKeHaYhY6c",
          projectId: "qualnotesdev",
          messagingSenderId: "925443941653",
          appId: "1:925443941653:web:02cf360eadf535d093351c"),
    );
  } else {
    await Firebase.initializeApp();
  }

  await Hive.initFlutter();
  final db = Get.put(HiveDb());
  await db.init();

  await checkForLocationPermission();
  final mapController = Get.put(MapGetxController());
  await mapController.init();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Archivo'),
      title: "Application",
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? AppPages.INITIAL
          : Routes.WELCOME,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> checkForLocationPermission() async {
  //checks and asks for loaction premmission
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      Get.snackbar(
        'Location denied',
        'This app needs location permission to function as intended!',
      );
    }
  }
}
