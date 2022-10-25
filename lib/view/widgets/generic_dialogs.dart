import 'package:flutter/material.dart';
import 'package:keep_it_g/localization/keys.dart';
import 'package:keep_it_g/localization/translations.i18n.dart';
import 'package:keep_it_g/main.dart';

class Dialogs {
  static showSnackBar(String message) {
    return ScaffoldMessenger.of(navigatorKey.currentContext as BuildContext).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static showDialogIfError(String errorMessage) {
    return showDialog(
      context: navigatorKey.currentContext as BuildContext,
      builder: (BuildContext context) => AlertDialog(
        content: Text(errorMessage),
        title: Text(TranslationKeys.error.i18n),
        actions: [
          TextButton(child: Text(TranslationKeys.ok.i18n), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  static Future<bool> showAreYouSureDialog(String? content) async {
    bool? response = await showDialog<bool>(
      context: navigatorKey.currentContext as BuildContext,
      builder: (BuildContext context) => AlertDialog(
        title: Text(content ?? ""),
        actions: [
          TextButton(
            child: Text(
              TranslationKeys.cancel.i18n,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(TranslationKeys.confirm.i18n),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    return response ?? false;
  }
}
