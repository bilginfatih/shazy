import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class NameTextFormField extends TextFormField {
  NameTextFormField({
    Key? key,
    TextEditingController? controller,
    String? hintText,
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
            hintText: hintText ?? 'Name',
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
        );
}
