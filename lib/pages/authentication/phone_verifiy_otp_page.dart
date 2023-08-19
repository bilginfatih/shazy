import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

import '../../widgets/buttons/primary_button.dart';
import '../../widgets/textfields/otp_text_form_field.dart';

class PhoneVerifiyOtpPage extends StatelessWidget {
  PhoneVerifiyOtpPage({super.key});

  final OtpFieldController _pinController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: BasePadding(
        context: context,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Forgot Password',
                style: context.textStyle.titleMedMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(12),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveWidth(25),
                ),
                child: Text(
                  'Code has been send to ***** ***70',
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyLargeRegular.copyWith(
                    color: HexColor('#D0D0D0'),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              OTPTextFormField(
                context: context,
                controller: _pinController,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              PrimaryButton(
                text: 'Verify',
                context: context,
                onPressed: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.setNewPassword);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
