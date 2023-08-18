import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/theme/themes.dart';

class BackAppBar extends AppBar {
  BackAppBar({
    Key? key,
    required BuildContext context,
    String? mainTitle,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  NavigationManager.instance.navigationToPop();
                },
                child: context.isLight ? SvgPicture.asset('assets/svg/angle-left.svg') : SvgPicture.asset('assets/svg/angle-left_white.svg'),
              ),
              SizedBox(
                width: context.responsiveWidth(5),
              ),
              Text(
                'Back',
                style: context.textStyle.subheadLargeRegular.copyWith(
                  color: context.isLight ? AppThemes.contentSecondary : Colors.white,
                ),
              ),
              Container(
                width: context.responsiveWidth(191),
                height: context.responsiveHeight(25),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  mainTitle ?? "",
                  style: context.textStyle.headlineSmallRegular.copyWith(color: context.isLight ? HexColor("#2A2A2A") : Colors.white),
                ),
              ),
            ],
          ),
        );
}