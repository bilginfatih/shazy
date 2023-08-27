import 'package:flutter/material.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/textfields/email_and_phone_text_form_field.dart';
import '../../widgets/textfields/password_text_form_field.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../widgets/padding/base_padding.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Sign In',
                  style: context.textStyle.titleMedMedium,
                ),
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
                hintText: 'Enter Your Password',
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
                onPressed: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.sendVerification);
                },
              ),
              SizedBox(
                height: context.responsiveHeight(110),
              ),
              CustomTextButton(
                text1: 'Don\'t have an account? ',
                text2: 'Sign Up',
                context: context,
                onTap: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.signUp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
