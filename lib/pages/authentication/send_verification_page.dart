import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/padding/base_padding.dart';
import 'package:shazy/widgets/textfields/email_and_phone_text_form_field.dart';

import '../../widgets/buttons/primary_button.dart';

class SendVerificationPage extends StatelessWidget {
  SendVerificationPage({super.key});

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
                  'Verifivation email or phone number',
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
                height: context.responsiveHeight(464),
              ),
              PrimaryButton(
                text: 'Send OTP',
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