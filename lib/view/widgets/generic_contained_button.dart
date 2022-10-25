import 'package:flutter/material.dart';

class GenericContainedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final FocusNode? focusNode;
  final ButtonStyle? buttonStyle;

  const GenericContainedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.focusNode,
    this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      focusNode: focusNode,
      child: Text(buttonText),
      style: buttonStyle ?? Theme.of(context).elevatedButtonTheme.style, // ?? ButtonStyle(
      //someProp: textSize ?? then customOne),
    );
  }
}
