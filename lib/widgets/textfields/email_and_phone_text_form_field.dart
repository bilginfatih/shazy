import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/extensions/string_extension.dart';
import '../../utils/theme/themes.dart';

class EmailAndPhoneTextFormField extends TextFormField {
  EmailAndPhoneTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Email or Phone Number',
            hintStyle: context.textStyle.subheadLargeMedium.copyWith(
              color: AppThemes.hintTextNeutral,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppThemes.borderSideColor,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Lütfen e-posta veya telefon numarası giriniz.';
            } else if (int.tryParse(value) != null) {
              if (!value.isValidPhoneNumber) {
                return 'Geçerli bir telefon numarası giriniz.';
              }
            } else if (!value.isValidEmail) {
              return 'Geçerli bir e-posta adresi giriniz.';
            }
            return null;
          },
        );
}
