import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/custom_text_button.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/textfields/email_and_phone_text_form_field.dart';
import 'package:shazy/widgets/textfields/email_text_form_field.dart';
import 'package:shazy/widgets/textfields/name_text_from_field.dart';
import 'package:shazy/widgets/textfields/password_text_form_field.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/padding/base_padding.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  TextEditingController _emailPhoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BackAppBar(context: context),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sign In',
                  style: context.textStyle.titleMedMedium,
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(24),
            ),
            EmailAndPhoneTextFormField(
              context: context,
              controller: _emailPhoneController,
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            PasswordTextFormField(
              context: context,
              controller: _passwordController,
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Forget password?',
                  style: context.textStyle.subheadSmallRegular.copyWith(
                    color: const Color(0xFFF44336),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(40),
            ),
            PrimaryButton(
              text: 'Sign Up',
              context: context,
              onPressed: () {},
            ),
            SizedBox(
              height: context.responsiveHeight(110),
            ),
            CustomTextButton(
              text1: 'Don\'t have an account? ',
              text2: 'Sign Up',
              context: context,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


/*
PrimaryButton(
                text: 'Sign Up',
                context: context,
                onPressed: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.signUp);
                },
              ), */