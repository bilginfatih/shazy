import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../utils/extensions/context_extension.dart';

import 'package:flutter/material.dart';

import '../../utils/theme/themes.dart';
import '../buttons/primary_button.dart';
import '../textfields/otp_text_form_field.dart';

class SecurityCodeDialog extends StatefulWidget {
  final BuildContext context;
  final VoidCallback onDialogClosed;
  SecurityCodeDialog({
    Key? key,
    required this.context,
    required this.onDialogClosed,
  }) : super(
          key: key,
        );

  @override
  State<SecurityCodeDialog> createState() => _SecurityCodeDialogState();
}

class _SecurityCodeDialogState extends State<SecurityCodeDialog> {
  final OtpFieldController _pinController = OtpFieldController();
  String _pin = '';
  bool _checkPin = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(230),
        bottom: context.responsiveHeight(295),
        left: context.responsiveWidth(14),
        right: context.responsiveWidth(14),
      ),
      child: Container(
        decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.responsiveHeight(15), horizontal: context.responsiveWidth(15)),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Text(
                  "Phone verification",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#2A2A2A"),
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(5),
                ),
                Text(
                  "Enter the code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HexColor("#A0A0A0"),
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(13),
                ),
                OTPTextFormField(
                  context: context,
                  controller: _pinController,
                  width: context.responsiveWidth(300),
                  fieldWidth: 50,
                  onChanged: (value) {
                    _pin = value;
                    print(_pin);
                    setState(() {
                      if (_pin == '34515') {
                        _checkPin = true;
                        print('başarılı');
                      } else {
                        _checkPin = false;
                        print('başarısız');
                      }
                    });
                  },
                ),
                SizedBox(
                  height: context.responsiveHeight(20),
                ),
                PrimaryButton(
                  context: context,
                  text: 'Start the Trip',
                  height: context.responsiveHeight(48),
                  width: context.responsiveWidth(290),
                  onPressed: () {
                    if (_checkPin) {
                      Navigator.pop(context);
                      widget.onDialogClosed();
                    }
                    print('Yanlış kod');
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
