import 'package:flutter/material.dart';

import '../../widgets/dialogs/error_dialog.dart';

class HelperFunctions {
  static HelperFunctions get instance => HelperFunctions();

  void showErrorDialog(BuildContext context, String title, String buttonText,
      VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (_) => ErrorDialog(
        context: context,
        title: title,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }
}
