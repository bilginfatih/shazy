import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/extensions/context_extension.dart';

class ErrorDialog extends Dialog {
  ErrorDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String buttonText,
    required VoidCallback onPressed,
    VoidCallback? onTap,
  }) : super(
          key: key,
          insetPadding: EdgeInsets.symmetric(
            horizontal: context.responsiveWidth(17),
            vertical: context.responsiveHeight(200),
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
                      // ignore: sort_child_properties_last
                      child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/svg/cancel.svg',
                          width: context.responsiveWidth(24),
                          height: context.responsiveHeight(24),
                          colorFilter: ColorFilter.mode(context.isLight ? Colors.black : Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      onTap: onTap ??
                          () {
                            NavigationManager.instance.navigationToPop();
                          },
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.responsiveHeight(10)),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/star_2.svg',
                    width: context.responsiveWidth(124),
                    height: context.responsiveHeight(124),
                  ),
                  Icon(
                    Icons.close,
                    size: context.responsiveWidth(80),
                    color: HexColor('#CB103F'),
                  ),
                ],
              ),
              SizedBox(height: context.responsiveHeight(40)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsiveWidth(12)),
                child: FittedBox(
                  child: Text(
                    maxLines: 5,
                    title,
                    style: context.textStyle.titleSmallMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: context.responsiveHeight(40)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsiveWidth(10)),
                child: PrimaryButton(
                  text: buttonText,
                  context: context,
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        );
}
