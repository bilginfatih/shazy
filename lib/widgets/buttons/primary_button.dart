import 'package:flutter/material.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class PrimaryButton extends SizedBox {
  PrimaryButton({
    Key? key,
    double? width,
    double? height,
    TextStyle? style,
    ButtonStyle? buttonStyle,
    bool isDisable = false,
    required String text,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          width: context.responsiveWidth(width ?? 362),
          height: context.responsiveHeight(height ?? 54),
          child: FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor: isDisable
                      ? AppThemes.lightenedColor
                      : AppThemes.lightPrimary500,
                ),
            child: Text(
              text,
              style: style ??
                  context.textStyle.subheadLargeRegular
                      .copyWith(color: Colors.white),
            ),
          ),
        );
}
