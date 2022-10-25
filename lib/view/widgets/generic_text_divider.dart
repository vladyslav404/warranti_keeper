import 'package:flutter/material.dart';

class GenericTextDivider extends StatelessWidget {
  final String text;
  const GenericTextDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(
            color: Colors.grey,
            endIndent: 20,
          ),
        ),
        Text(text),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            indent: 20,
          ),
        ),
      ],
    );
  }
}
