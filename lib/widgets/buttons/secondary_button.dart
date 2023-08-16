import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';

import '../../utils/theme/styles.dart';
/*
class SecondaryButton extends SizedBox {
  SecondaryButton({
    Key? key,
    double? width,
    double? height,
    TextStyle? style,
    required String text,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          width: context.responsiveWidth(width ?? 362),
          height: context.responsiveHeight(height ?? 54),
          child: FilledButton(
          
            onPressed: onPressed,
            style: ButtonStyle(
              elevation: ,
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: AppThemes.lightTheme.colorScheme.primary),
                ),
              ),
            ),
            child: Text(
              text,
              style: style ??
                  AppTextStyles.subheadLarge
                      .copyWith(color: Colors.grey.shade800),
            ),
          ),
        );
}
*/