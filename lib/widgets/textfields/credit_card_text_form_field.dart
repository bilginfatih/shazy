import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class CreditCardTextFormField extends TextFormField {
  CreditCardTextFormField({
    Key? key,
    required BuildContext context,
    required TextEditingController controller,
  }) : super(
          key: key,
          controller: controller,
          cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CardNumberInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'Card Number',
            hintStyle: context.textStyle.subheadLargeMedium.copyWith(
              color: AppThemes.hintTextNeutral,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppThemes.borderSideColor,
              ),
            ),
            focusedBorder: context.isLight
                ? null
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppThemes.lightPrimary500,
                    ),
                  ),
          ),
        );
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}
