import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teegram/screens/signup_screen.dart';

import './screens/login_screen.dart';
import './responsive/mobile_screen_layout.dart';
import './responsive/responsive_layout_screen.dart';
import './responsive/web_screen_layout.dart';
import './utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCHg4JOGFbE8xTBlmUIAykAFKM8i07CY2o",
          authDomain: "teegram-90c29.firebaseapp.com",
          projectId: "teegram-90c29",
          storageBucket: "teegram-90c29.appspot.com",
          messagingSenderId: "147716583765",
          appId: "1:147716583765:web:13c48a58f9b63c02eaffdc"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      // home: LoginScreen(),
      // home: const ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      // ),
    );
  }
}
