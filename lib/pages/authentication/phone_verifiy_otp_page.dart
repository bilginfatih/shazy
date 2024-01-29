import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../controllers/authentiaction/authentication_controller.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/otp_text_form_field.dart';

class PhoneVerifiyOtpPage extends StatefulWidget {
  const PhoneVerifiyOtpPage({super.key});

  @override
  State<PhoneVerifiyOtpPage> createState() => _PhoneVerifiyOtpPageState();
}

class _PhoneVerifiyOtpPageState extends State<PhoneVerifiyOtpPage> {
  final AuthController _controller = AuthController();
  String _pin = '';
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
                fieldWidth: 50,
                width: MediaQuery.of(context).size.width,
                onChanged: (value) {
                  _pin = value;
                  setState(() {});
                },
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              PrimaryButton(
                text: 'Verify',
                context: context,
                isDisable: _pin.length != 5,
                onPressed: _controller.forgotPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
