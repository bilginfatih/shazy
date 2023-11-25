import 'package:flutter/material.dart';

import '../../utils/extensions/context_extension.dart';

class BasePadding extends Padding {
  BasePadding({
    Key? key,
    required BuildContext context,
    required Widget child,
  }) : super(
            key: key,
            padding: EdgeInsets.symmetric(
              horizontal: context.responsiveWidth(16),
              vertical: context.responsiveHeight(16),
            ),
            child: child);
}
