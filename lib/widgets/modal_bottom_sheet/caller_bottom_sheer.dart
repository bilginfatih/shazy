import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../core/init/network/network_manager.dart';
import '../../utils/theme/themes.dart';
import '../buttons/primary_button.dart';
import '../containers/payment_method_container.dart';
import '../icons/circular_svg_icon.dart';

// ignore: must_be_immutable
class CallerBottomSheet extends StatefulWidget {
  final bool showAnathorBuild;
  CallerBottomSheet({
    super.key,
    this.height,
    this.buttonTextCancel,
    required this.context,
    required this.pickingUpText,
    required this.imagePath,
    required this.customerName,
    required this.startText,
    this.onPressedCancel,
    required this.paymentText,
    required this.totalPaymentText,
    required this.verificationCodeText,
    required this.showAnathorBuild,
    required this.shareMyTripText,
    required this.shareMyTripButtonText,
    required this.shareButtonTapped,
    required this.cardNumber,
    required this.expires,
  });

  String? buttonTextCancel;
  String? buttonTextStart;

  final BuildContext context;
  final String customerName;
  double? height;
  final String imagePath;
  VoidCallback? onPressedCancel;
  final String pickingUpText;
  final String startText;
  final String paymentText;
  final String totalPaymentText;
  final String verificationCodeText;
  final String shareMyTripText;
  final String shareMyTripButtonText;
  final VoidCallback shareButtonTapped;
  final String cardNumber;
  final String expires;

  @override
  State<CallerBottomSheet> createState() => _CallerBottomSheetState();
}

class _CallerBottomSheetState extends State<CallerBottomSheet> {
  Padding _buildCustomerInfo(BuildContext context, String imagePath,
      String customerName, String startText) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.responsiveHeight(19),
          left: context.responsiveWidth(14),
          bottom: context.responsiveHeight(context.height < 620 ? 2 : 12)),
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

  Padding _buildBottomButtons(BuildContext context, String? buttonTextCancel,
      VoidCallback? onPressedCancel) {
    return Padding(
      padding: EdgeInsets.only(top: 26, left: 14, right: 14, bottom: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print('wp mesajlaşma atacak');
            },
            child: CircularSvgIcon(
              context: context,
              assetName: 'assets/svg/sms.svg',
            ),
          ),
          PrimaryButton(
            width: context.responsiveWidth(147),
            height: context.responsiveHeight(48),
            text: buttonTextCancel ?? 'Cancel'.tr(),
            context: context,
            onPressed: onPressedCancel ?? () {},
            style: context.textStyle.subheadLargeMedium
                .copyWith(fontSize: context.responsiveFont(15)),
          ),
        ],
      ),
    );
  }

  Row _buildLocationRow(
    BuildContext context,
    String text1,
    String text2,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 11),
          height: context.responsiveHeight(23),
          width: context.responsiveWidth(194),
          child: Text(
            text1,
            style: context.textStyle.subheadLargeMedium.copyWith(
              color:
                  context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
              fontSize: context.responsiveFont(18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 59.0),
          child: Container(
            height: context.responsiveHeight(36),
            width: context.responsiveWidth(125),
            child: Text(
              text2,
              style: context.textStyle.titleLargeMedium.copyWith(
                fontSize: context.responsiveFont(26),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildShareMyTripText(
    BuildContext context,
    String text1,
  ) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.responsiveWidth(15.0)),
          child: SizedBox(
            height: context.responsiveHeight(30),
            width: context.responsiveWidth(194),
            child: Text(
              text1,
              style: context.textStyle.subheadLargeMedium.copyWith(
                  color: context.isLight
                      ? HexColor('#5A5A5A')
                      : HexColor('#E8E8E8'),
                  fontSize: context.responsiveFont(16)),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildShareTripButton(
    BuildContext context,
    String text1,
    VoidCallback? shareButtonTapped,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.responsiveWidth(15)),
          child: SizedBox(
            height: context.responsiveHeight(context.height < 600 ? 50 : 23),
            width: context.responsiveWidth(334),
            child: Text(
              text1,
              style: TextStyle(
                fontSize: context.responsiveFont(12),
                fontWeight: FontWeight.w300,
                color:
                    context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: shareButtonTapped ?? () {},
          child: SvgPicture.asset(
            "assets/svg/location.svg",
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.customeHeight(widget.height ?? 0.58),
      decoration: BoxDecoration(
        color: context.isLight ? Colors.white : AppThemes.darkBg,
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
              style: context.textStyle.subheadLargeMedium
                  .copyWith(fontSize: context.responsiveFont(16)),
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
          if (widget.showAnathorBuild)
            SizedBox(
              height: context.responsiveHeight(22),
            ),
          if (widget.showAnathorBuild)
            _buildLocationRow(
                context, widget.paymentText, widget.totalPaymentText),
          SizedBox(
            height: context.responsiveHeight(12),
          ),
          widget.showAnathorBuild
              ? Padding(
                  padding: const EdgeInsets.only(right: 22.0, left: 11),
                  child: PaymetMethodContainer(
                    context: context,
                    assetName: 'visa',
                    text1: widget.cardNumber,
                    text2: '${'expires'.tr()}: ${widget.expires}',
                    opacitiy: 1,
                  ),
                )
              : _buildShareMyTripText(context, widget.shareMyTripText),
          if (widget.showAnathorBuild == false)
            _buildShareTripButton(context, widget.shareMyTripButtonText,
                widget.shareButtonTapped),
          if (widget.showAnathorBuild)
            SizedBox(
              height: context.responsiveHeight(5),
            ),
          if (widget.showAnathorBuild)
            Center(
              child: Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: context.responsiveFont(11),
                  fontWeight: FontWeight.w500,
                  color: context.isLight
                      ? HexColor('#5A5A5A')
                      : HexColor('#E8E8E8'),
                ),
              ),
            ),
          if (widget.showAnathorBuild)
            SizedBox(
              height: context.responsiveHeight(5),
            ),
          if (widget.showAnathorBuild)
            Center(
              child: Text(
                widget.verificationCodeText,
                style: TextStyle(fontSize: context.responsiveFont(14)),
              ),
            ),
          if (widget.showAnathorBuild)
            _buildBottomButtons(
                context, widget.buttonTextCancel, widget.onPressedCancel),
        ],
      ),
    );
  }
}
