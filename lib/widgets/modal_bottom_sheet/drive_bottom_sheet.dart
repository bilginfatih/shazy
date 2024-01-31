// Sürücünün sürüşü onaylaması için çıkan bottom sheet
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/textfields/otp_text_form_field.dart';

import '../../utils/theme/themes.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

class DriveBottomSheet extends StatefulWidget {
  DriveBottomSheet(
      {super.key,
      this.height,
      this.buttonText,
      required this.context,
      required this.pickingUpText,
      required this.imagePath,
      required this.customerName,
      required this.startText,
      required this.location1TextTitle,
      required this.location1Text,
      required this.location2TextTitle,
      required this.location2Text,
      required this.onPressed});

  String? buttonText;
  final BuildContext context;
  final String customerName;
  double? height;
  final String imagePath;
  final String location1Text;
  final String location1TextTitle;
  final String location2Text;
  final String location2TextTitle;
  final VoidCallback onPressed;
  final String pickingUpText;
  final String startText;

  @override
  State<DriveBottomSheet> createState() => _DriveBottomSheetState();
}

class _DriveBottomSheetState extends State<DriveBottomSheet> {
  Padding _buildCustomerInfo(BuildContext context, String imagePath,
      String customerName, String startText) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.responsiveHeight(19),
          left: context.responsiveWidth(14),
          bottom: context.responsiveHeight(16)),
      child: Row(
        children: [
          Container(
            width: context.responsiveWidth(54),
            height: context.responsiveHeight(54),
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          SizedBox(
            width: context.responsiveWidth(9),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: context.textStyle.subheadLargeMedium,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppThemes.warningYellow700,
                    ),
                    Text(
                      startText,
                      style: const TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding _buildBottomButtons(
      BuildContext context, String? buttonText, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.responsiveHeight(26),
          left: context.responsiveWidth(14),
          right: context.responsiveWidth(14),
          bottom: context.responsiveHeight(23)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*GestureDetector(
            onTap: () {
              // TODO: ne olacağını sor
            },
            child: CircularSvgIcon(
              context: context,
              assetName: 'assets/svg/sms.svg',
            ),
          ),*/
          SecondaryButton(
            width: 159,
            text: buttonText ?? 'Cancel'.tr(),
            context: context,
            onPressed: onPressed,
          ),
          PrimaryButton(
            width: 159,
            text: buttonText ?? 'Start the Trip'.tr(),
            context: context,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  Padding _buildLocationRow(
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: context.isLight ? HexColor('#5A5A5A') : Colors.white,
                  ),
                ),
                Text(
                  text2,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#5A5A5A'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCodeColumn(BuildContext context, String? buttonText) =>
      buttonText == null
          ? SizedBox(
              height: context.responsiveHeight(18),
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: context.responsiveHeight(8),
                  ),
                  Text(
                    'enterCode'.tr(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.19,
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(8),
                  ),
                  OTPTextFormField(
                      context: context,
                      width: context.responsiveWidth(200),
                      fieldWidth: 27,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 10),
                      textStyle: context.textStyle.bodySmallMedium),
                  SizedBox(
                    height: context.responsiveHeight(20),
                  ),
                ],
              ),
            );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.customeHeight(widget.height ?? 0.51),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveWidth(24)),
          topRight: Radius.circular(context.responsiveWidth(24)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveWidth(14),
                  vertical: context.responsiveHeight(11),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.close),
                  ),
                ),
              ),*/
          Padding(
            padding: EdgeInsets.only(
              top: context.responsiveHeight(34),
              left: context.responsiveWidth(14),
              bottom: context.responsiveHeight(15),
            ),
            child: Text(
              widget.pickingUpText,
              style: context.textStyle.subheadLargeMedium,
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          _buildCustomerInfo(
              context, widget.imagePath, widget.customerName, widget.startText),
          const Divider(
            thickness: 1,
          ),
          _buildCodeColumn(context, widget.buttonText),
          _buildLocationRow(
            context,
            'map5',
            widget.location1TextTitle,
            widget.location1Text,
          ),
          SizedBox(
            height: context.responsiveHeight(29),
          ),
          _buildLocationRow(
            context,
            'map4',
            widget.location2TextTitle,
            widget.location2Text,
          ),
          _buildBottomButtons(context, widget.buttonText, widget.onPressed),
        ],
      ),
    );
  }
}
