import 'package:flutter/material.dart';
import 'package:recibo/screens/home/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SplashScreen(
            seconds: 1,
            navigateAfterSeconds: HomeScreen(),
            loaderColor: Colors.white,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff1a1a1a),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: ExactAssetImage(
                  'images/receipt.png',
                ),
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  'AGENDA \n& \nRECIBO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.amber[900],
                        offset: Offset(0, 4.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
