import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../utils/extensions/context_extension.dart';

class OTPTextFormField extends OTPTextField {
  OTPTextFormField({
    Key? key,
    OtpFieldController? controller,
    EdgeInsets? contentPadding,
    double? spaceBetween,
    TextStyle? textStyle,
    required BuildContext context,
    required double width,
    required double fieldWidth,
    void Function(String)? onChanged,
    void Function(String)? onCompleted,
  }) : super(
          key: key,
          controller: controller,
          length: 5,
          isDense: true,
          width: width,
          keyboardType: TextInputType.number,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldWidth: context.responsiveWidth(fieldWidth),
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 7,
          style: textStyle?.copyWith(
                  color:
                      context.isLight ? HexColor("#414141") : Colors.black) ??
              context.textStyle.titleMedSemibold.copyWith(
                  color: context.isLight ? HexColor("#414141") : Colors.black),
          otpFieldStyle: OtpFieldStyle(
            focusBorderColor: HexColor("#BC8CE3"),
            backgroundColor: Colors.white,
          ),
          spaceBetween: context.responsiveWidth(spaceBetween ?? 10),
          onChanged: onChanged,
          onCompleted: onCompleted,
        );
}
