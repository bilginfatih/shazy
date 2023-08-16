import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/extensions/string_extension.dart';
import '../../utils/theme/themes.dart';

class PasswordTextFormField extends TextFormField {
  PasswordTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter Your Password',
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
              return 'Parola boş olamaz.';
            } else if (!value.isValidPassword) {
              return 'Geçerli bir parola giriniz.';
            }
            return null;
          },
        );
}
