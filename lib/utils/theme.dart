import 'package:flutter/material.dart';
import 'package:keep_it_g/constants/routes.dart';

final ThemeData appTheme = ThemeData(
  //fontFamily: AppConst.fontNunito,
  primaryColor: const Color(0xFF51565F),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      primary: const Color(0xFF51565F),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
      textStyle: const TextStyle(
        // fontFamily: AppConst.fontNunito,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  ),
);
