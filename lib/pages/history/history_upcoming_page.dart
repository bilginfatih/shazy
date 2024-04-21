import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import 'controller/history_upcoming_controller.dart';
import '../../widgets/containers/two_select_container.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/custom_app_bar.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/padding/base_padding.dart';

class HistoryUpcomingPage extends StatefulWidget {
  const HistoryUpcomingPage({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<HistoryUpcomingPage> createState() => _HistoryUpcomingPageState();
}

class _HistoryUpcomingPageState extends State<HistoryUpcomingPage> {
  final TextEditingController _commentTextController = TextEditingController();
  final _controller = HistoryUpcomingController();

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
      int index,
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
                          SizedBox(
                            width: context.responsiveWidth(2),
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
                            width: context.responsiveWidth(
                                context.width < 330 ? 120 : 158),
                          ),
                          Text(
                            cancel ? 'canceled'.tr() : '',
                            style: GoogleFonts.poppins(
                                fontSize: context.responsiveWidth(11),
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
            buttonText != ''
                ? SizedBox(
                    // comment button
                    width: context.responsiveWidth(253),
                    height: context.responsiveHeight(32),
                    child: SecondaryButton(
                      text: buttonText,
                      context: context,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          context: context,
                          builder: (_) => Observer(builder: (context) {
                            return CommentBottomSheet(
                              selectedIndex: _controller.starSelectedIndex,
                              context: context,
                              textController: _commentTextController,
                              onPressed: () {
                                _controller.sendComment(context,
                                    _commentTextController.text, index);
                              },
                              onPressedRatingBar:
                                  _controller.changeStarSelectedIndex,
                              text:
                                  '${'youRated'.tr()} $name${' ${_controller.starSelectedIndex}'} ${'star'.tr()}',
                            );
                          }),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: context.responsiveHeight(buttonText != '' ? 7 : 0),
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
                            color: context.isLight
                                ? HexColor('#5A5A5A')
                                : HexColor('#B8B8B8'),
                          ),
                        ),
                        Text(
                          'time'.tr(),
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
                      fontSize: context.responsiveFont(10),
                      fontWeight: FontWeight.w500,
                      color: context.isLight
                          ? HexColor('#5A5A5A')
                          : HexColor('#B8B8B8')),
                ),
                FittedBox(
                  child: Text(
                    text2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      fontSize: context.responsiveFont(8),
                      fontWeight: FontWeight.w400,
                      color: HexColor('#B8B8B8'),
                    ),
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
                  color: context.isLight
                      ? HexColor('#5A5A5A')
                      : HexColor('#B8B8B8')),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        scaffoldKey: widget.scaffoldKey,
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
              height: context.responsiveHeight(19),
            ),
            Observer(builder: (_) {
              return SizedBox(
                height: context.responsiveHeight(550),
                child: _controller.driverList.isEmpty &&
                        _controller.passengerList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _controller.isDriverSelected
                        ? ListView.builder(
                            itemCount: _controller.driverList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildContainer(
                                context,
                                _controller.driverList[index].userProfile
                                        ?.userModel?.name ??
                                    '',
                                '${_controller.driverList[index].userProfile?.averagePoint} (531 reviews)',
                                '${_controller.driverList[index].driveModel?.fromShortAddress}',
                                '${_controller.driverList[index].driveModel?.fromAddress}',
                                '${_controller.driverList[index].driveModel?.toShortAddress}',
                                '${_controller.driverList[index].driveModel?.toAddress}',
                                '${_controller.driverList[index].driveModel?.date}',
                                '16:38 - 16.42',
                                '+220.00₺',
                                '#388E3D',
                                _controller.driverList[index].commentId ==
                                            null ||
                                        _controller
                                                .driverList[index].commentId ==
                                            ''
                                    ? 'reviewPassenger'.tr()
                                    : '',
                                index,
                                cancel: _controller
                                        .driverList[index].driveModel?.status
                                        .toString() ==
                                    'Canceled',
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: _controller.passengerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildContainer(
                                context,
                                _controller.passengerList[index].userProfile
                                        ?.userModel?.name ??
                                    '',
                                '${_controller.passengerList[index].userProfile?.averagePoint} (531 reviews)',
                                '${_controller.passengerList[index].driveModel?.fromShortAddress}',
                                '${_controller.passengerList[index].driveModel?.fromAddress}',
                                '${_controller.passengerList[index].driveModel?.toShortAddress}',
                                '${_controller.passengerList[index].driveModel?.toAddress}',
                                '${_controller.passengerList[index].driveModel?.date}',
                                '16:38 - 16.42',
                                '220.00₺',
                                '#5A5A5A',
                                _controller.passengerList[index].commentId ==
                                            'null' ||
                                        _controller
                                                .driverList[index].commentId ==
                                            ''
                                    ? 'reviewTrip'.tr()
                                    : '',
                                cancel: _controller
                                        .driverList[index].driveModel?.status
                                        .toString() ==
                                    'Canceled',
                                index,
                              );
                            },
                          ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
