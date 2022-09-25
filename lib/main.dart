import 'package:flutter/material.dart';
import 'package:qualnotes/pages/privacy_policy.dart';
import './pages/live_location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp>  _fbApp = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //printDebug("error");
            print("erorr");
            return Text("error");
          } else if (snapshot.hasData) {
            return MaterialApp(
                title: 'QualNote',
                theme: ThemeData(
                  primarySwatch: mapBoxBlue,
                ),
                home:  MyWebView(),
                routes: <String, WidgetBuilder>{
                  LiveLocationPage.route: (context) => const LiveLocationPage(),
                  MyWebView.route: (context) => MyWebView(),
                  // PhotoElicitation .... LiveLocationPage.route: (context) => const LiveLocationPage(),
                  // AutoE .... LiveLocationPage.route: (context) => const LiveLocationPage(),
                  // About
                  // Privacy
                  // Tutorials
                  // Examples
                  // My account
                }
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } // builder
      );
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = MaterialColor(
  _bluePrimary,
  <int, Color>{
    50: Color(0xFFE7EBFE),
    100: Color(0xFFC4CEFE),
    200: Color(0xFF9CADFD),
    300: Color(0xFF748CFC),
    400: Color(0xFF5773FB),
    500: Color(_bluePrimary),
    600: Color(0xFF3352F9),
    700: Color(0xFF2C48F9),
    800: Color(0xFF243FF8),
    900: Color(0xFF172EF6),
  },
);
