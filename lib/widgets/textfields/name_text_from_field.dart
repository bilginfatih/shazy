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
          decoration: InputDecoration(
            hintText: hintText ?? 'Name',
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
        );
}
