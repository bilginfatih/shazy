import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

class OptionContainer extends GestureDetector {
  OptionContainer({
    Key? key,
    VoidCallback? onTap,
    BoxBorder? border,
    Widget? child,
    required BuildContext context,
    required Color color,
  }) : super(
          key: key,
          onTap: onTap,
          child: Container(
            height: context.responsiveHeight(80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
              border: border,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.responsiveHeight(15),
                horizontal: context.responsiveWidth(17),
              ),
              child: child,
            ),
          ),
        );
}
