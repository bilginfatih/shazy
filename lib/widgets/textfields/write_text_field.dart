import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class WriteTextField extends TextField {
  WriteTextField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
    required String hintText,
    required HexColor borderColor,
    required int maxLines,
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
            hintText: hintText,
            hintStyle: TextStyle(color: HexColor("#D0D0D0")),
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor,
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
          maxLines: maxLines,
        );
}
