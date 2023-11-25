import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/extensions/context_extension.dart';

class ShadowButton extends Container {
  ShadowButton({
    Key? key,
    required BuildContext context,
    required Widget icon,
    required VoidCallback onTap,
  }) : super(
          key: key,
          width: context.responsiveWidth(34),
          height: context.responsiveHeight(34),
          decoration: BoxDecoration(
            color: context.isLight ? Colors.grey.shade100 : HexColor('#D0D0D0'),
            borderRadius: BorderRadius.circular(4),
            boxShadow: context.isLight
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    )
                  ]
                : null,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: icon,
          ),
        );
}
