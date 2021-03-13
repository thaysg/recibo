import 'package:flutter/material.dart';
import 'package:recibo/components/constants.dart';

class DeleteData extends StatelessWidget {
  final String alertTitle;
  final VoidCallback onTap;

  const DeleteData({@required this.alertTitle, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kdefaultColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      title: Text(
        alertTitle,
        style: ktitleTextStyle,
      ),
      content: Builder(
        builder: (context) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Confirmar Exclusão?',
                  style: ktitleTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          primary: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 110,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff009933),
                          primary: Colors.white,
                        ),
                        onPressed: onTap,
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
