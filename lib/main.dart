import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Nunito"),
      home: Scaffold(
        body: Container(
          child: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LoginPage();
              } else {
                return ErrorPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
