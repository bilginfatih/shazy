import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/country_phone_text_form_field.dart';
import '../../widgets/textfields/email_text_form_field.dart';
import '../../widgets/textfields/gender_text_from_field.dart';
import '../../widgets/textfields/name_text_from_field.dart';
import '../../widgets/textfields/tc_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _tcController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
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
                  'Sign Up',
                  style: context.textStyle.titleMedMedium,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(24),
              ),
              SizedBox(
                height: context.responsiveHeight(60),
                width: context.responsiveWidth(362),
                child: NameTextFormField(
                  context: context,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              SizedBox(
                height: context.responsiveHeight(60),
                width: context.responsiveWidth(362),
                child: EmailTextFormField(
                  context: context,
                  controller: _emailController,
                  text: 'Email',
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              SizedBox(
                height: context.responsiveHeight(60),
                width: context.responsiveWidth(362),
                child: TcTextFormField(
                  context: context,
                  controller: _tcController,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CountryPhoneTextFormField(
                context: context,
              ),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              SizedBox(
                height: context.responsiveHeight(60),
                width: context.responsiveWidth(362),
                child: GenderTextFormField(
                  context: context,
                  controller: _genderController,
                  text: 'Gender',
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: RoundCheckBox(
                      borderColor: Colors.green[600],
                      checkedWidget: const Icon(Icons.check, size: 14),
                      size: 16,
                      onTap: (selected) {},
                    ),
                  ),
                  SizedBox(width: context.responsiveWidth(10)),
                  Expanded(
                    // Halile sor
                    child: RichText(
                      text: TextSpan(
                        style: context.textStyle.bodySmallMedium,
                        children: [
                          TextSpan(
                            text: "By signing up. you agree to the ",
                            style: context.textStyle.bodySmallMedium.copyWith(
                              color: AppThemes.borderSideColor,
                            ),
                          ),
                          TextSpan(
                            text: "Terms of service",
                            style: context.textStyle.bodySmallMedium.copyWith(
                              color: AppThemes.lightPrimary500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigationManager.instance.navigationToPage(
                                    NavigationConstant.setPassword);
                              },
                          ),
                          TextSpan(
                            text: " and ",
                            style: context.textStyle.bodySmallMedium.copyWith(
                              color: AppThemes.borderSideColor,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy policy.",
                            style: context.textStyle.bodySmallMedium.copyWith(
                              color: AppThemes.lightPrimary500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigationManager.instance.navigationToPage(
                                    NavigationConstant.completeProfile);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.responsiveHeight(22),
              ),
              PrimaryButton(
                text: 'Sign Up',
                context: context,
                onPressed: () {},
              ),
              SizedBox(
                height: context.responsiveHeight(80),
              ),
              CustomTextButton(
                text1: 'Already have an account? ',
                text2: 'Sign in',
                context: context,
                onTap: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.signIn);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
