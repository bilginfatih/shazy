import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

class BasePadding extends Padding {
  BasePadding({
    Key? key,
    required BuildContext context,
    required Widget child,
  }) : super(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveWidth(16),
            vertical: context.responsiveHeight(16),
          ),
          child: child,
        );
}
