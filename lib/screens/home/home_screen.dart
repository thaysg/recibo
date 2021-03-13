import 'package:flutter/material.dart';
import 'package:recibo/screens/agenda/agenda_screen.dart';
import 'package:recibo/screens/recibo/receipt_screen.dart';

enum CurrentPage {
  recibo,
  agenda,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrentPage selectedPage;
  int _indiceAtual = 0;

  bool current = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Receipt(),
      AgendaScreen(),
    ];

    return Scaffold(
      body: screens[_indiceAtual],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
            currentIndex: _indiceAtual,
            onTap: (indice) {
              setState(() {
                _indiceAtual = indice;
              });
            },
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            backgroundColor: Color(0xff1a1a1a),
            items: [
              BottomNavigationBarItem(
                label: 'Recibos',
                icon: Icon(
                  Icons.receipt_long,
                  size: 35,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Agenda',
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 35,
                ),
              ),
            ]),
      ),
    );
  }
}
