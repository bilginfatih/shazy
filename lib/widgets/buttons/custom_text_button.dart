import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';

class CustomTextButton extends Row {
  CustomTextButton({
    Key? key,
    VoidCallback? onTap,
    required String text1,
    required String text2,
    required BuildContext context,
  }) : super(key: key, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            text1,
            style: context.textStyle.bodyLargeRegular,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              text2,
              style: context.textStyle.bodyLargeRegular.copyWith(color: AppThemes.lightPrimary500),
            ),
          ),
        ]);
}
