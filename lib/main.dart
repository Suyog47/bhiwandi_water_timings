import 'dart:io';
import 'package:BWT/constants/colors.dart';
import 'package:BWT/screens/dashboard.dart';
import 'package:BWT/screens/feedback.dart';
import 'package:BWT/screens/splash_screen.dart';
import 'package:BWT/utils/navigations.dart';
import 'package:BWT/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCwA44pEiOP8UUL_8yKVH0n7bSwE5Hf4ws',
          appId: '1:322145844936:android:c84f33c66fb8061db62ffd',
          messagingSenderId: '322145844936',
          projectId: 'bwtlinking'));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: themeBlueColor));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initDynamicLinks(context);

    return GetMaterialApp(
      routes: Routes().createRoutes(),
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
    );
  }
}

void initDynamicLinks(BuildContext context) async {
  FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? linkData) {
    final Uri? deepLink = linkData?.link;

    if(deepLink!=null) {
      var route = deepLink.queryParameters.values.first;
      Get.toNamed(route);
    }
  });
}
