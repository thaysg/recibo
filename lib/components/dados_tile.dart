import 'package:flutter/material.dart';
import 'package:recibo/components/constants.dart';

class DadosTile extends StatelessWidget {
  final String dadosText;

  const DadosTile({@required this.dadosText});
  Widget build(BuildContext context) {
    return Text(
      dadosText,
      style: kDadosTile,
    );
  }
}
