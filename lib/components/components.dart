import 'package:flutter/material.dart';
import 'package:recibo/components/constants.dart';

class DialogScreen extends StatelessWidget {
  final Widget myWidget;
  final String alertTitle;

  DialogScreen({@required this.myWidget, @required this.alertTitle});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kdefaultColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      title: Text(
        alertTitle,
        style: kTextFieldColor,
      ),
      content: Builder(
        builder: (context) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .39,
            child: myWidget,
          );
        },
      ),
    );
  }
}
