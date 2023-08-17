import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/custom_text_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/otp_text_form_field.dart';

class VerifyOtpPage extends StatefulWidget {
  VerifyOtpPage({Key? key}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  OtpFieldController _otpController = OtpFieldController();
  @override
  Widget build(BuildContext context) {
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
                'Phone verification',
                style: context.textStyle.titleMedMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(12),
              ),
              Text(
                'Enter your OTP code',
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor("#D0D0D0"),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              OTPTextFormField(
                context: context,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CustomTextButton(
                text1: 'Didn’t receive code? ',
                text2: 'Resend again',
                context: context,
                onTap: () {
                  NavigationManager.instance.navigationToPage(NavigationConstant.welcome);
                },
              ),
              SizedBox(
                height: context.responsiveHeight(50),
              ),
              PrimaryButton(
                text: 'Verify',
                context: context,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
