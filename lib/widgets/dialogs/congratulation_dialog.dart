import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';

class CongratulationDialog extends Dialog {
  CongratulationDialog({Key? key, required BuildContext context})
      : super(
          key: key,
          insetPadding: EdgeInsets.symmetric(
            horizontal: context.responsiveWidth(17),
            vertical: context.responsiveHeight(152),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveWidth(10),
                    vertical: context.responsiveHeight(10),
                  ),
                  child: Material(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.white,
                        child: SvgPicture.asset(
                          'assets/svg/cancel.svg',
                          width: context.responsiveWidth(24),
                          height: context.responsiveHeight(24),
                        ),
                      ),
                      onTap: () {
                        NavigationManager.instance.navigationToPop();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.responsiveHeight(45)),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset(
                    "assets/png/star_1.png",
                    width: context.responsiveWidth(124),
                    height: context.responsiveHeight(124),
                  ),
                  Icon(
                    Icons.check_sharp,
                    size: context.responsiveWidth(80),
                    color: HexColor('#43A048'),
                  ),
                ],
              ),
              SizedBox(height: context.responsiveHeight(23)),
              Text(
                "Congratulation",
                style: context.textStyle.titleSmallMedium,
              ),
              SizedBox(height: context.responsiveHeight(7)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveWidth(50)),
                child: Text(
                  "Your account is ready to use. You will be redirected to the Home Page in a few seconds.",
                  style: context.textStyle.bodySmallMedium
                      .copyWith(color: HexColor('#898989')),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
}
