import 'package:buzzlite/home.dart';
import 'package:flutter/material.dart';

// packages

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset(
          'assets/applogo.png',
          width: 500,
          height: 600,
        ),
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.scale,
      ),
    );
  }
}
