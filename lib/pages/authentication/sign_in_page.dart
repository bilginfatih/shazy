import 'package:flutter/material.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Create an account',
              context: context,
              onPressed: () {
                NavigationManager.instance.navigationToPage(NavigationConstant.signUp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
