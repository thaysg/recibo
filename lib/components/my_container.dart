import 'package:flutter/material.dart';
import 'package:recibo/components/constants.dart';

class MyContainer extends StatelessWidget {
  final Widget myChild;

  const MyContainer({@required this.myChild});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * .24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kdefaultColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: myChild,
        ),
      ),
    );
  }
}
