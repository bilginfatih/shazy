import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/string_extension.dart';
import '../../utils/theme/styles.dart';
import '../../utils/theme/themes.dart';

class EmailTextFormField extends TextFormField {
  EmailTextFormField({
    Key? key,
    TextEditingController? controller,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: AppTextStyles.subheadLargeMedium.copyWith(
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
              return 'E-posta adresi boş olamaz.';
            } else if (!value.isValidEmail) {
              return 'Geçerli bir e-posta adresi giriniz.';
            }
            return null;
          },
        );
}
