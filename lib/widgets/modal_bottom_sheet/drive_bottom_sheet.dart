// Sürücünün sürüşü onaylaması için çıkan bottom sheet
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/theme/themes.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../icons/circular_svg_icon.dart';

// ignore: must_be_immutable
class DriveBottomSheet extends StatefulWidget {
  final bool showSecondaryButton;
  DriveBottomSheet({
    super.key,
    this.height,
    this.buttonTextCancel,
    this.buttonTextStart,
    required this.context,
    required this.pickingUpText,
    required this.imagePath,
    required this.customerName,
    required this.startText,
    required this.location1TextTitle,
    required this.location1Text,
    required this.location2TextTitle,
    required this.location2Text,
    this.onPressedCancel,
    required this.onPressedStart,
    required this.showSecondaryButton,
  });

  String? buttonTextCancel;
  String? buttonTextStart;

  final BuildContext context;
  final String customerName;
  double? height;
  final String imagePath;
  final String location1Text;
  final String location1TextTitle;
  final String location2Text;
  final String location2TextTitle;
  VoidCallback? onPressedCancel;
  final VoidCallback onPressedStart;
  final String pickingUpText;
  final String startText;

  @override
  State<DriveBottomSheet> createState() => _DriveBottomSheetState();
}

class _DriveBottomSheetState extends State<DriveBottomSheet> {
  Padding _buildCustomerInfo(BuildContext context, String imagePath, String customerName, String startText) {
    return Padding(
      padding: EdgeInsets.only(top: context.responsiveHeight(19), left: context.responsiveWidth(14), bottom: context.responsiveHeight(16)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                  style: context.textStyle.subheadLargeMedium.copyWith(fontSize: context.responsiveFont(16)),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppThemes.warningYellow700,
                    ),
                    Text(
                      startText,
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: context.responsiveFont(10),
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
      BuildContext context, String? buttonTextCancel, String? buttonTextStart, VoidCallback? onPressedCancel, VoidCallback onPressedStart) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.responsiveHeight(26), left: context.responsiveWidth(14), right: context.responsiveWidth(14), bottom: context.responsiveHeight(23)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: context.responsiveHeight(50),
              child: GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse('https://wa.me/905532732686'));
                },
                child: CircularSvgIcon(
                  context: context,
                  assetName: 'assets/svg/sms.svg',
                ),
              ),
            ),
          ),
          SizedBox(
            width: context.responsiveWidth(25),
          ),
          if (widget.showSecondaryButton) // Eğer showSecondaryButton true ve index 0 ise göster
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(right: context.responsiveWidth(6)),
                child: SecondaryButton(
                  //height: context.responsiveHeight(48),
                  text: buttonTextCancel ?? 'Cancel'.tr(),
                  context: context,
                  onPressed: onPressedCancel ?? () {},
                  style: context.textStyle.subheadLargeMedium.copyWith(fontSize: context.responsiveFont(15)),
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: PrimaryButton(
              /*width: widget.showSecondaryButton
                  ? null
                  : context.responsiveWidth(189),
              height: context.responsiveHeight(48),*/
              text: buttonTextStart ?? 'startTheTrip'.tr(),
              context: context,
              onPressed: onPressedStart,
              style: context.textStyle.subheadLargeMedium.copyWith(fontSize: context.responsiveFont(15)),
            ),
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
              padding: EdgeInsets.only(top: context.responsiveHeight(4), left: context.responsiveWidth(10), right: context.responsiveWidth(6)),
              child: SvgPicture.asset('assets/svg/$assetName.svg'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: GoogleFonts.poppins(
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.w500,
                    color: context.isLight ? HexColor('#5A5A5A') : Colors.white,
                  ),
                ),
                Text(
                  text2,
                  style: GoogleFonts.poppins(
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w400,
                    color: context.isLight ? HexColor('#5A5A5A') : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.customeHeight(widget.height ?? 0.57),
      decoration: BoxDecoration(
        color: context.isLight ? Colors.white : HexColor('#35383F'),
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
              style: context.textStyle.subheadLargeMedium.copyWith(fontSize: context.responsiveFont(16)),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          _buildCustomerInfo(context, widget.imagePath, widget.customerName, widget.startText),
          const Divider(
            thickness: 1,
          ),
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
          _buildBottomButtons(context, widget.buttonTextCancel, widget.buttonTextStart, widget.onPressedCancel, widget.onPressedStart),
        ],
      ),
    );
  }
}
