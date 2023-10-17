import 'package:BWT/screens/dashboard.dart';
import 'package:BWT/screens/feedback.dart';
import 'package:BWT/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  Map<String, Widget Function(BuildContext context)> createRoutes(){
    return {
      '/splash': (BuildContext context) => const SplashScreen(),
      '/dashboard': (BuildContext context) => const Dashboard(),
      '/feedback': (BuildContext context) => const FeedbackScreen()
    };
  }
}