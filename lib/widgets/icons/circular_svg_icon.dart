import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';

class CircularSvgIcon extends Container {
  CircularSvgIcon(
      {Key? key, required BuildContext context, required String assetName})
      : super(
          key: key,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(
              width: 1,
              color: AppThemes.lightTheme.colorScheme.primary,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.responsiveHeight(7.0)),
            child: SvgPicture.asset(assetName),
          ),
        );
}
