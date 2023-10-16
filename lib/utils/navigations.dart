import 'package:BWT/screens/dashboard.dart';
import 'package:BWT/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Navigate {
  void toSplash(BuildContext context, [Map? data]) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ));
  }

  void toDashboard(BuildContext context, [Map? data]) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ));
  }
}
