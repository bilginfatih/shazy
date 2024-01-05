import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class SecondaryButton extends SizedBox {
  SecondaryButton({
    Key? key,
    double? width,
    double? height,
    TextStyle? style,
    Color? borderColor,
    required String text,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          width: context.responsiveWidth(width ?? 362),
          height: context.responsiveHeight(height ?? 54),
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
                backgroundColor:
                    context.isLight ? Colors.white : Colors.transparent,
                foregroundColor: context.isLight
                    ? AppThemes.lightPrimary500
                    : Colors.grey[500],
                side: BorderSide(
                  strokeAlign: 1,
                  width: 2,
                  color: borderColor ?? AppThemes.lightPrimary500,
                )),
            child: Text(
              text,
              style: style ??
                  context.textStyle.subheadLargeMedium.copyWith(
                      color:
                          !context.isLight ? AppThemes.lightPrimary500 : null),
            ),
          ),
        );
}
