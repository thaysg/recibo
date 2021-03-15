import 'package:flutter/material.dart';
import 'package:recibo/screens/splash_screen/my_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff0a0e21),
        scaffoldBackgroundColor: Color(0xff212121), //Color(0xff282A35),
      ),
      home: MySplashScreen(),
    );
  }
}
