import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../../widgets/app_bars/back_app_bar.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/buttons/secondary_button.dart';

class DriverCompleteSecond extends StatelessWidget {
  const DriverCompleteSecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'driver'.tr(),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: context.responsiveWidth(40.0),
            top: context.responsiveHeight(198.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'thankYouApplication'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: HexColor("#494949"),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(28),
            ),
            Text(
              'weWillReturn48Hours'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: HexColor("#494949"),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(311),
            ),
            Row(
              children: [
                SecondaryButton(
                  context: context,
                  text: 'tryAgain'.tr(),
                  height: context.responsiveHeight(54),
                  width: context.responsiveWidth(140),
                  style: TextStyle(color: HexColor("#414141")),
                  onPressed: () {},
                ),
                SizedBox(
                  width: context.responsiveWidth(25),
                ),
                PrimaryButton(
                  context: context,
                  text: 'home'.tr(),
                  height: context.responsiveHeight(54),
                  width: context.responsiveWidth(140),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
