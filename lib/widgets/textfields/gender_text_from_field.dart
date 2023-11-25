import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class GenderTextFormField extends DropdownButtonFormField {
  GenderTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
    required String text,
  }) : super(
          key: key,
          decoration: InputDecoration(
            hintText: text,
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
          iconEnabledColor:
              context.isLight ? HexColor("#414141") : HexColor("#D0D0D0"),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(
              value: 0,
              child: Text("Male"),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text("Female"),
            ),
          ],
          onChanged: (v) {
            if (controller != null) {
              if (v == 0) {
                controller.text = 'male';
              } else {
                controller.text = 'female';
              }
            }
          },
        );
}
