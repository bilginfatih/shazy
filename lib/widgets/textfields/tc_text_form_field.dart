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
          decoration: InputDecoration(
            hintText: 'TC',
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
