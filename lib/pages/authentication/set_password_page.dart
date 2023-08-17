import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/password_text_form_field.dart';

class SetPasswordPage extends StatefulWidget {
  SetPasswordPage({Key? key}) : super(key: key);

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: SingleChildScrollView(
        child: BasePadding(
          context: context,
          child: Column(
            children: [
              Text(
                'Set password',
                style: context.textStyle.titleMedMedium,
              ),
              SizedBox(
                height: context.responsiveHeight(12),
              ),
              Text(
                'Set your password',
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor("#D0D0D0"),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              PasswordTextFormField(
                context: context,
                controller: _passwordController,
                hintText: 'Enter Your Password',
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              PasswordTextFormField(
                context: context,
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
              ),
              SizedBox(
                height: context.responsiveHeight(10),
              ),
              Row(
                children: [
                  SizedBox(
                    height: context.responsiveHeight(19),
                    width: context.responsiveWidth(277),
                    child: Text(
                      'Atleast 1 number or a special character',
                      style: context.textStyle.subheadSmallRegular.copyWith(
                        color: HexColor("#A6A6A6"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.responsiveHeight(43),
              ),
              PrimaryButton(
                text: 'Register',
                context: context,
                onPressed: () {
                  NavigationManager.instance.navigationToPage(
                    NavigationConstant.verifyOtp,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
