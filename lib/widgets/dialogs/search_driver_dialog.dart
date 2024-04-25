import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';

import '../../utils/theme/themes.dart';
import '../buttons/secondary_button.dart';

class SearchDriverDialog extends Dialog {
  SearchDriverDialog({
    Key? key,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          child: Container(
            width: context.responsiveWidth(353),
            height: context.responsiveHeight(222),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: context.responsiveHeight(20),
                ),
                Text(
                  'searchingForDriver'.tr(),
                  style: context.textStyle.headlineSmallMedium.copyWith(
                    color: HexColor('#5A5A5A'),
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(20),
                ),
                CircularProgressIndicator(
                  backgroundColor: AppThemes.secondary500.withOpacity(0.1),
                  color: AppThemes.secondary500,
                ),
                SizedBox(
                  height: context.responsiveHeight(6),
                ),
                Text(
                  'thisMayTakeFewSecond'.tr(),
                  style: TextStyle(
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w300,
                    color: HexColor('#5A5A5A'),
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(21),
                ),
                SecondaryButton(
                  width: context.responsiveWidth(110),
                  height: context.responsiveHeight(50),
                  text: 'cancelCall'.tr(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: HexColor('#2A2A2A')),
                  context: context,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        );
}
