import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

class OTPTextFormField extends OTPTextField {
  OTPTextFormField({
    Key? key,
    OtpFieldController? controller,
    required BuildContext context,
  }) : super(
          key: key,
          controller: controller,
                length: 5,
                isDense: true,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: context.responsiveWidth(50),
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 7,
                style: context.textStyle.titleMedSemibold.copyWith(color: context.isLight ? HexColor("#414141") : Colors.black),
                otpFieldStyle: OtpFieldStyle(
                  focusBorderColor: HexColor("#BC8CE3"),
                  backgroundColor: Colors.white,
                ),
                spaceBetween: context.responsiveWidth(10),
                onChanged: (pin) {
                  print("Changed: " + pin);
                },
                onCompleted: (pin) {
                  print("Completed: " + pin);
                },
        );
}
