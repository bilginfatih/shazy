import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';
import 'option_container.dart';

class PaymetMethodContainer extends Opacity {
  PaymetMethodContainer({Key? key, double opacitiy = 0.45, String? assetName, required BuildContext context, required String text1, required String text2})
      : super(
          key: key,
          opacity: opacitiy,
          child: OptionContainer(
            context: context,
            select: true,
            height: context.responsiveHeight(context.height < 620 ? 130 : 100),
            border: Border.all(
              width: 1,
              color: AppThemes.lightTheme.colorScheme.primary,
            ),
            color: AppThemes.lightPrimary50,
            child: Row(
              children: [
                //SvgPicture.asset('assets/svg/payment/$assetName.svg'),
                SizedBox(
                  width: context.responsiveWidth(13),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text1,
                      style: context.textStyle.subheadLargeMedium.copyWith(color: HexColor('#5A5A5A'), fontSize: context.responsiveFont(16)),
                    ),
                    Text(text2, style: context.textStyle.subheadSmallMedium.copyWith(fontSize: context.responsiveFont(14)))
                  ],
                ),
              ],
            ),
          ),
        );
}
