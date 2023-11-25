import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controllers/authentiaction/authentication_controller.dart';
import '../../models/user/user_model.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/email_and_phone_text_form_field.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final AuthController _controller = AuthController();
  final TextEditingController _emailPhoneTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BasePadding(
        context: context,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'signIn'.tr(),
                style: context.textStyle.titleMedMedium,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(24),
            ),
            EmailAndPhoneTextFormField(
              context: context,
              controller: _emailPhoneTextEditingController,
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            _buildPasswordTextFormField(context),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            _buildForgetPasswordButton(context),
            SizedBox(
              height: context.responsiveHeight(40),
            ),
            _buildSignInButton(context),
            SizedBox(
              height: context.responsiveHeight(110),
            ),
            _buildSignUpButton(context),
          ],
        ),
      ),
    );
  }

  PasswordTextFormField _buildPasswordTextFormField(BuildContext context) {
    return PasswordTextFormField(
      context: context,
      controller: _passwordTextEditingController,
      hintText: 'enterYourPassword'.tr(),
    );
  }

  CustomTextButton _buildSignUpButton(BuildContext context) {
    return CustomTextButton(
      text1: 'dontHaveAccount'.tr(),
      text2: 'signUp'.tr(),
      context: context,
      onTap: _controller.goToSignUpPage,
    );
  }

  Align _buildForgetPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _controller.goToForgetPasswordPage,
        child: Text(
          'forgetPassword'.tr(),
          style: context.textStyle.subheadSmallRegular.copyWith(
            color: const Color(0xFFF44336),
          ),
        ),
      ),
    );
  }

  PrimaryButton _buildSignInButton(BuildContext context) {
    return PrimaryButton(
      text: 'signIn'.tr(),
      context: context,
      onPressed: () async {
        UserModel user = UserModel(
          email: _emailPhoneTextEditingController.text,
          password: _passwordTextEditingController.text,
        );
        await _controller.login(user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: _buildBody(context),
    );
  }
}
