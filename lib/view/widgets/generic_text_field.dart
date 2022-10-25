import 'package:flutter/material.dart';

class GenericTextField extends StatelessWidget {
  final bool? alignLabelWithHint;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool isEnabled;
  final bool isObscure;
  final TextInputType? keyboardType;
  final Widget? label;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  const GenericTextField({
    Key? key,

    ///variables
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.isObscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,

    ///callbacks
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,

    ///decorations
    this.alignLabelWithHint = true,
    this.hintText,
    this.label,
    this.suffix,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      enabled: isEnabled,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        alignLabelWithHint: alignLabelWithHint,
        hintText: hintText,
        label: label,
        suffix: suffix,

        ///suffixIcon requires less space then suffix
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Color(0xffE1E1E1),
          ),
        ),
      ),
    );
  }
}
