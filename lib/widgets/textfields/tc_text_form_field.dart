import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class TcTextFormField extends TextFormField {
  TcTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
  }) : super(
          key: key,
          controller: controller,
          cursorColor: context.isLight ? null : AppThemes.lightPrimary500,
          keyboardType: TextInputType.number,
          onTapOutside: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: 'TC',
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
