import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';

import '../../utils/theme/styles.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(text: 'text', context: context, onPressed: () {}),
            SecondaryButton(text: 'text', context: context, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
