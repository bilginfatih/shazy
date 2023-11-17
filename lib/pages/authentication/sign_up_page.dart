import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import '../../controllers/authentiaction/authentication_controller.dart';
import '../../models/user/user_model.dart';
import '../../utils/extensions/context_extension.dart';
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

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final AuthController _controller = AuthController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _genderTextEditingController =
      TextEditingController();

  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final TextEditingController _phoneTextEditingController =
      TextEditingController();

  final TextEditingController _surnameTextEditingController =
      TextEditingController();

  final TextEditingController _tcTextEditingController =
      TextEditingController();

  var _termsCheck = false;

  PrimaryButton _buildSignUpButton(BuildContext context) {
    return PrimaryButton(
      text: 'signUp'.tr(),
      context: context,
      onPressed: () {
        UserModel model = UserModel(
          name: _nameTextEditingController.text,
          surname: _surnameTextEditingController.text,
          email: _emailTextEditingController.text,
          identificationNumber: _tcTextEditingController.text,
          phone: _phoneTextEditingController.text,
          gender: _genderTextEditingController.text,
        );
        _controller.goToVerifyOTP(model, _termsCheck);
      },
    );
  }

  Row _buildTermsCheck(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 13),
          child: RoundCheckBox(
            borderColor: Colors.green[600],
            checkedWidget: const Icon(Icons.check, size: 14),
            size: 16,
            onTap: (selected) {
              _termsCheck = selected ?? false;
            },
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
                  text: 'signUpTerms1'.tr(),
                  style: context.textStyle.bodySmallMedium.copyWith(
                    color: AppThemes.borderSideColor,
                  ),
                ),
                TextSpan(
                  text: 'termsOfService'.tr(),
                  style: context.textStyle.bodySmallMedium.copyWith(
                    color: AppThemes.lightPrimary500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: yapılacak
                    },
                ),
                TextSpan(
                  text: ' ${'and'.tr()} ',
                  style: context.textStyle.bodySmallMedium.copyWith(
                    color: AppThemes.borderSideColor,
                  ),
                ),
                TextSpan(
                  text: 'privacyPolicy'.tr(),
                  style: context.textStyle.bodySmallMedium.copyWith(
                    color: AppThemes.lightPrimary500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: yapılacak
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                  'signUp'.tr(),
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
                  controller: _nameTextEditingController,
                  context: context,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(24),
              ),
              SizedBox(
                height: context.responsiveHeight(60),
                width: context.responsiveWidth(362),
                child: NameTextFormField(
                  controller: _surnameTextEditingController,
                  hintText: 'surname'.tr(),
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
                  controller: _emailTextEditingController,
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
                  controller: _tcTextEditingController,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CountryPhoneTextFormField(
                controller: _phoneTextEditingController,
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
                  controller: _genderTextEditingController,
                  text: 'gender'.tr(),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              _buildTermsCheck(context),
              SizedBox(
                height: context.responsiveHeight(22),
              ),
              _buildSignUpButton(context),
              SizedBox(
                height: context.responsiveHeight(80),
              ),
              CustomTextButton(
                text1: 'alreadyHaveAnAccount'.tr(),
                text2: 'signIn'.tr(),
                context: context,
                onTap: _controller.goToSignInPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
