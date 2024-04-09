import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/app_bars/back_app_bar.dart';

class DriverComplete extends StatelessWidget {
  const DriverComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Driver',
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40.0, top: 198.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your application.',
              style: GoogleFonts.poppins(
                fontSize: context.responsiveHeight(30),
                fontWeight: FontWeight.w400,
                color: HexColor("#494949"),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(28),
            ),
            Text(
              'We will return within 48 hours.',
              style: GoogleFonts.poppins(
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.w400,
                color: HexColor("#494949"),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(301),
            ),
            PrimaryButton(
              context: context,
              text: 'Home',
              onPressed: () {},
              height: context.responsiveHeight(54),
              width: context.responsiveWidth(314),
            ),
          ],
        ),
      ),
    );
  }
}
