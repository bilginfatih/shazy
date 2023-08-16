import 'package:flutter/material.dart';
import '../../utils/theme/styles.dart';
import '../../utils/theme/themes.dart';

class NameTextFormField extends TextFormField {
  NameTextFormField({
    Key? key,
    TextEditingController? controller,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Name',
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
        );
}
