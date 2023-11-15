import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shazy/controllers/authentiaction/authentication_controller.dart';
import 'package:shazy/models/user/user_model.dart';
import '../../utils/extensions/context_extension.dart';

import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/otp_text_form_field.dart';

// ignore: must_be_immutable
class VerifyOtpPage extends StatelessWidget {
  VerifyOtpPage({super.key});

  final AuthController _controller = AuthController();
  final OtpFieldController _otpController = OtpFieldController();
  String _pin = '';
  late UserModel _user;

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: BackAppBar(
        context: context,
      ),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Column(
            children: [
              Text(
                'phoneVerification'.tr(),
                style: context.textStyle.titleMedMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(12),
              ),
              Text(
                'enterOTPCode'.tr(),
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor("#D0D0D0"),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              OTPTextFormField(
                controller: _otpController,
                context: context,
                fieldWidth: 50,
                width: MediaQuery.of(context).size.width,
                onCompleted: (pin) {
                  _pin = pin;
                },
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CustomTextButton(
                text1: 'didReceiveCode'.tr(),
                text2: 'resendAgain'.tr(),
                context: context,
                onTap: _controller.resendCode,
              ),
              SizedBox(
                height: context.responsiveHeight(427),
              ),
              PrimaryButton(
                text: 'verify'.tr(),
                context: context,
                onPressed: () {
                  _controller.verifyOTP(_user, _pin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
