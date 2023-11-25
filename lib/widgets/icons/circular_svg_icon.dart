import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class CircularSvgIcon extends Container {
  CircularSvgIcon({
    Key? key,
    required BuildContext context,
    required String assetName,
    final BoxDecoration? decoration,
  }) : super(
          key: key,
          decoration: decoration ??
              BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(
                    width: 1,
                    color: AppThemes.lightTheme.colorScheme.primary,
                  ),
                  color: context.isLight ? null : Colors.white),
          child: Padding(
            padding: EdgeInsets.all(context.responsiveHeight(7.0)),
            child: SvgPicture.asset(assetName),
          ),
        );
}
