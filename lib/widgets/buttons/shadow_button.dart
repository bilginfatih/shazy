import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5.0,
                offset: const Offset(5, 5),
              )
            ],
          ),
          child: GestureDetector(
            onTap:onTap,
            child: icon,
          ),
        );
}
