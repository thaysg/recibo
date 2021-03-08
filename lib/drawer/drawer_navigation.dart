import 'package:flutter/material.dart';
import 'package:recibo/drawer/helper/drawer_helper.dart';
import 'package:recibo/screens/agenda/agenda_screen.dart';
import 'package:recibo/screens/recibo/receipt_screen.dart';

class DrawerScreen extends StatefulWidget {
  final Contact contact;

  DrawerScreen({this.contact});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 220,
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color(0xff0a0e21),
                    backgroundImage: AssetImage('images/receipt.png'),
                  ),
                  accountName: Text(
                    'Agenda & Recibo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(''),
                  decoration: BoxDecoration(
                    color: Color(0xff0a0e21),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AgendaScreen(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.calendar_today_rounded,
                  size: 40,
                  color: Color(0xff0a0e21),
                ),
                title: Text(
                  'Agenda',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Receipt(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.receipt_long,
                  size: 40,
                  color: Color(0xff0a0e21),
                ),
                title: Text(
                  'Recibos',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
