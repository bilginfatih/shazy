import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'controller/history_upcoming_controller.dart';
import '../../widgets/containers/two_select_container.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/drawer/custom_drawer.dart';
import '../../widgets/padding/base_padding.dart';


// TODO: kayitli veri eklendiğinde statikten çıkarılacaktır.
class HistoryUpcomingPage extends StatefulWidget {
  const HistoryUpcomingPage({super.key});

  @override
  State<HistoryUpcomingPage> createState() => _HistoryUpcomingPageState();
}

class _HistoryUpcomingPageState extends State<HistoryUpcomingPage> {
  final _controller = HistoryUpcomingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  Padding _buildContainer(
      BuildContext context,
      String name,
      String star,
      String startingLocation1,
      String startingLocation2,
      String endLocation1,
      String endLocation2,
      String date,
      String time,
      String price,
      String color,
      String buttonText,
      {bool cancel = false}) {
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
                        name,
                        style: context.textStyle.subheadSmallRegular,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/star.svg',
                            width: 10,
                          ),
                          Text(
                            star,
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
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: HexColor('#F44336')),
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
              startingLocation1,
              startingLocation2,
              text3: date,
            ),
            SizedBox(
              height: context.responsiveHeight(11),
            ),
            _buildLocationRow(
              context,
              'map4',
              endLocation1,
              endLocation2,
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            SizedBox(
              width: context.responsiveWidth(253),
              height: context.responsiveHeight(32),

              child: SecondaryButton(
                  text: buttonText, context: context, onPressed: () {}),
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
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          time,
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
                  ),
                  const VerticalDivider(
                    color: Color.fromARGB(255, 199, 198, 198),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      price,
                      textAlign: TextAlign.center,
                      style: context.textStyle.subheadLargeMedium.copyWith(
                        color: HexColor(color),
                      ),
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

  Padding _buildLocationRow(BuildContext context, String assetName, String text1, String text2, {String text3 = ''}) => Padding(
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
        child: Column(
          children: [
            Observer(
              builder: (_) => TwoSelectContainer(
                context: context,
                text1: 'driver'.tr(),
                text2: 'passenger'.tr(),
                onTap1: () {
                  _controller.userSelect(true);
                },
                onTap2: () async {
                  _controller.userSelect(false);
                },
                isSelectedDriver: _controller.isDriverSelected,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Observer(builder: (_) {
              return SizedBox(
                height: context.responsiveHeight(550),
                child: _controller.isDriverSelected
                    ? ListView.builder(
                        itemCount: 5, //_controller.driverList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildContainer(
                            context,
                            'Zübeyir X',
                            '4.9 (531 reviews)',
                            'Starting Location',
                            '4140 Parker Rd. Allentown, New...',
                            'Shop',
                            '2972 Westheimer Rd. Santa Ana, Illinois 85486 ',
                            '29.08.2023',
                            '16:38 - 16.42',
                            '+220.00₺',
                            '#388E3D',
                            'Review Passenger',
                            cancel: true,
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: 5, //_controller.passengerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildContainer(
                            context,
                            'Toygun X.',
                            '4.2 (531 reviews)',
                            'Starting Location',
                            '4140 Parker Rd. Allentown, New...',
                            'Shop',
                            '2972 Westheimer Rd. Santa Ana, Illinois 85486 ',
                            '29.08.2023',
                            '16:38 - 16.42',
                            '220.00₺',
                            '#5A5A5A',
                            'Review Trip',
                            cancel: true,
                          );
                        },
                      ),
              );
            }),
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
}
