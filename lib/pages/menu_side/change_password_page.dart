import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Change Password',
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            PasswordTextFormField(
              context: context,
              hintText: 'Old Password',
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            PasswordTextFormField(
              context: context,
              hintText: 'New Password',
            ),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            PasswordTextFormField(
              context: context,
              hintText: 'Confirm Password',
            ),
            SizedBox(
              height: context.responsiveHeight(32),
            ),
            PrimaryButton(
              context: context,
              text: 'Save',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
