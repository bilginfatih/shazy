import 'package:easy_localization/easy_localization.dart';
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
          cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
          onTapOutside: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: 'emailOrPhone'.tr(),
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
