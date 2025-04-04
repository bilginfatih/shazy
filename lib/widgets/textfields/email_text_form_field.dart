import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/extensions/string_extension.dart';
import '../../utils/theme/themes.dart';

class EmailTextFormField extends TextFormField {
  EmailTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
    required String text,
  }) : super(
          key: key,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
          onTapOutside: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: text,
            hintStyle: context.textStyle.subheadLargeMedium.copyWith(
              color: AppThemes.hintTextNeutral,
            ),
            focusedBorder: context.isLight
                ? null
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppThemes.lightPrimary500,
                    ),
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
