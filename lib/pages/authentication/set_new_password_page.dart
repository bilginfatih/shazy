import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class SetNewPassword extends StatelessWidget {
  SetNewPassword({super.key});

  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

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
                'Set New password',
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
                  'Set your new password',
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyLargeRegular.copyWith(
                    color: HexColor('#D0D0D0'),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              PasswordTextFormField(
                hintText: 'Enter Your New Password',
                context: context,
                controller: _passwordController1,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              PasswordTextFormField(
                hintText: 'Confirm Password',
                context: context,
                controller: _passwordController2,
              ),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Atleast 1 number or a special character',
                  textAlign: TextAlign.center,
                  style: context.textStyle.subheadSmallMedium.copyWith(
                    color: HexColor('#A6A6A6'),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(43),
              ),
              PrimaryButton(
                text: 'Save',
                context: context,
                onPressed: () {        
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
