import 'package:flutter/material.dart';
import 'package:recibo/components/constants.dart';

class MyButtons extends StatelessWidget {
  final String title;
  final Color bgColour;
  final Color textColour;

  final VoidCallback onPress;

  const MyButtons({
    @required this.title,
    @required this.onPress,
    @required this.bgColour,
    @required this.textColour,
  });
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: bgColour,
          primary: textColour,
        ),
        onPressed: onPress,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: kDialogButton,
        ),
      ),
    );
  }
}
