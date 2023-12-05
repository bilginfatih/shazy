import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/extensions/context_extension.dart';
import '../buttons/primary_button.dart';

import '../../utils/theme/themes.dart';
import '../buttons/secondary_button.dart';

class DriverDialog extends Padding {
  DriverDialog({
    Key? key,
    required BuildContext context,
    required String price,
    required String star,
    required String location1TextTitle,
    required String location1Text,
    required String location2TextTitle,
    required String location2Text,
    required VoidCallback cancelOnPressed,
    required VoidCallback acceptOnPressed,
  }) : super(
          key: key,
          padding: EdgeInsets.only(
            top: context.responsiveHeight(340),
            bottom: context.responsiveHeight(76),
            left: context.responsiveWidth(14),
            right: context.responsiveWidth(14),
          ),
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: context.responsiveHeight(15),
                  horizontal: context.responsiveWidth(15)),
              child: Column(
                children: [
                  Text(
                    price,
                    style: context.textStyle.titleXlargeRegular,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppThemes.warningYellow700,
                      ),
                      Text(
                        star,
                        style: context.textStyle.bodySmallRegular,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.responsiveHeight(15),
                  ),
                  Divider(
                    thickness: 1.5,
                    color: AppThemes.lightPrimary500,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(15),
                  ),
                  _buildLocationRow(
                    context,
                    'map5',
                    location1TextTitle,
                    location1Text,
                  ),
                  SizedBox(
                    height: context.responsiveHeight(29),
                  ),
                  _buildLocationRow(
                    context,
                    'map4',
                    location2TextTitle,
                    location2Text,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SecondaryButton(
                        width: context.responsiveWidth(160),
                        text: 'cancel'.tr(),
                        context: context,
                        onPressed: cancelOnPressed,
                      ),
                      PrimaryButton(
                        width: context.responsiveWidth(160),
                        text: 'accept'.tr(),
                        context: context,
                        onPressed: acceptOnPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

  static Padding _buildLocationRow(
    BuildContext context,
    String assetName,
    String text1,
    String text2,
  ) =>
      Padding(
        padding: EdgeInsets.only(
          left: context.responsiveWidth(8),
          right: context.responsiveWidth(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: context.responsiveHeight(4),
                  left: context.responsiveWidth(10),
                  right: context.responsiveWidth(6)),
              child: SvgPicture.asset('assets/svg/$assetName.svg'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#5A5A5A'),
                  ),
                ),
                Text(
                  text2,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#B8B8B8'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
