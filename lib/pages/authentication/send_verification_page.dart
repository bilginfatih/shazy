import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shazy/controllers/authentiaction/authentication_controller.dart';

import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/email_and_phone_text_form_field.dart';

class SendVerificationPage extends StatelessWidget {
  SendVerificationPage({super.key});
  final AuthController _controller = AuthController();

  final TextEditingController _emailAndPhoneController =
      TextEditingController();

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
                  'verifivationEmairOrPhone'.tr(),
                  style: context.textStyle.titleMedMedium,
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(40),
              ),
              EmailAndPhoneTextFormField(
                context: context,
                controller: _emailAndPhoneController,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              PrimaryButton(
                text: 'sendOTP'.tr(),
                context: context,
                onPressed: () {
                  // TODO:
                  _controller.verifyPhone('phone');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
