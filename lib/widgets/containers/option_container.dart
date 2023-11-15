import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class OptionContainer extends GestureDetector {
  OptionContainer({
    Key? key,
    VoidCallback? onTap,
    BoxBorder? border,
    Widget? child,
    Color? color,
    double? height,
    required BuildContext context,
    required bool select,
  }) : super(
          key: key,
          onTap: onTap,
          child: Container(
            height: context.responsiveHeight(context.height < 600 ? 100 :  (height ?? 60)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: border,
              color: color ?? (!context.isLight
                  ? (select ? AppThemes.teriary400 : HexColor('#1F212A'))
                  : null),
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
