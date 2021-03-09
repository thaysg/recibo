import 'package:flutter/material.dart';
import 'package:recibo/screens/agenda/agenda_screen.dart';
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
            navigateAfterSeconds: AgendaScreen(),
            loaderColor: Colors.transparent,
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage(
                  'images/receipt.png',
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Text(
                  'Agenda \n& \nRecibo',
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
