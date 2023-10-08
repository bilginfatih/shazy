import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/app_bars/custom_app_bar.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/drawer/custom_drawer.dart';
import 'package:shazy/widgets/padding/base_padding.dart';


class HistoryUpcomingPage extends StatelessWidget {
  HistoryUpcomingPage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: _scaffoldKey,
      ),
      body: BasePadding(
        context: context,
        child: ListView(
          children: [
            _buildContainer(context),
            _buildContainer(context, cancel: true),
            _buildContainer(context),
            _buildContainer(context),
          ],
        ),
      ),
      drawer: CustomDrawer(
        context: context,
        name: 'M. Halil',
        email: 'zubeyirx@email.com',
      ),
    );
  }

  Padding _buildContainer(BuildContext context, {bool cancel = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppThemes.lightPrimary500,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: context.responsiveWidth(7),
                top: context.responsiveHeight(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(),
                  SizedBox(
                    width: context.responsiveWidth(8),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zübeyir X.',
                        style: context.textStyle.subheadSmallRegular,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/star.svg',
                            width: 10,
                          ),
                          Text(
                            '4.9 (531 reviews)',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                              color: HexColor('#A0A0A0'),
                            ),
                          ),
                          SizedBox(
                            width: context.responsiveWidth(158),
                          ),
                          Text(
                            cancel ? 'Canceled' : '',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#F44336')),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            _buildLocationRow(
              context,
              'map5',
              'Current location',
              '4140 Parker Rd. Allentown, New...',
              text3: '29.08.2023',
            ),
            SizedBox(
              height: context.responsiveHeight(11),
            ),
            _buildLocationRow(
              context,
              'map4',
              'Shop',
              '2972 Westheimer Rd. Santa Ana, Illinois 85486 ',
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            SizedBox(
              width: context.responsiveWidth(253),
              height: context.responsiveHeight(32),
              child: SecondaryButton(
                  text: 'Review Trip', context: context, onPressed: () {}),
            ),
            SizedBox(
              height: context.responsiveHeight(7),
            ),
            const Divider(
              color: Color.fromARGB(255, 199, 198, 198),
            ),
            SizedBox(
              height: context.responsiveHeight(43),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '16:38 - 16.42',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: HexColor('#5A5A5A'),
                        ),
                      ),
                      Text(
                        'Saat',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#B8B8B8'),
                        ),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: Color.fromARGB(255, 199, 198, 198),
                  ),
                  Text(
                    '220.00₺',
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: HexColor('#5A5A5A'),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(8),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildLocationRow(
          BuildContext context, String assetName, String text1, String text2,
          {String text3 = ''}) =>
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
                SizedBox(
                  height: context.responsiveHeight(4),
                ),
                Text(
                  text1,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#5A5A5A'),
                  ),
                ),
                Text(
                  text2,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    color: HexColor('#B8B8B8'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              text3,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: HexColor('#5A5A5A'),
              ),
            ),
          ],
        ),
      );
}
