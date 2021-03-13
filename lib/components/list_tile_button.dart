import 'package:flutter/material.dart';

class ListTileButton extends StatelessWidget {
  final onPress;
  final Icon myIcon;

  const ListTileButton({
    @required this.onPress,
    @required this.myIcon,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: myIcon,
    );
  }
}
