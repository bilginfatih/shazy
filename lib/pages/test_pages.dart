import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/modal_bottom_sheet/drive_bottom_sheet.dart';
import '../models/comment/comment_model.dart';
import '../models/drive/drive_model.dart';
import '../services/comment/comment_service.dart';
import '../services/drive/drive_service.dart';
import '../services/security/security_service.dart';
import '../utils/extensions/context_extension.dart';
import '../utils/theme/themes.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/containers/payment_method_container.dart';
import '../widgets/icons/circular_svg_icon.dart';
import '../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import '../widgets/rating_bars/star_rating_bar.dart';
import '../widgets/textfields/otp_text_form_field.dart';
import '../core/init/cache/cache_manager.dart';
import '../models/user/user_model.dart';
import '../services/history/history_service.dart';
import '../services/user/user_service.dart';
import '../widgets/padding/base_padding.dart';

// TODO: End pointleri test etmek için olan sayfa proda çıkmadan kaldırılacak
class TestPage extends StatelessWidget {
  TestPage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: BasePadding(
        context: context,
        child: Center(
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                    name: 'test2',
                    email: 'test234@gmail.com',
                    password: 'test222',
                    passwordConfirmation: 'test222',
                    identificationNumber: '222222223',
                    surname: 'test',
                    gender: 'male',
                    phone: '99999999998',
                  );
                  await UserService.instance.register(model);
                },
                child: Text('Register'),
              ),
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                    email: 'test234@gmail.com',
                    password: 'test222',
                  );
                  await UserService.instance.login(model);
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response =
                      await HistoryService.instance.getDriverHistory();
                },
                child: Text('GetDriverHistory'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response =
                      await HistoryService.instance.getPassengerHistory();
                  print(response);
                },
                child: Text('GetPassengerHistory'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data =
                      await CacheManager.instance.getData('user', 'email');
                  print(data);
                },
                child: Text('HiveTest'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await UserService.instance.getUser();
                  print(data);
                },
                child: Text('User'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await UserService.instance
                      .getAnotherUser('9a9659af-6549-41d0-be1a-f75ba16e2c60');
                },
                child: Text('Another User'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    context: context,
                    builder: (_) => CommentBottomSheet(
                      onPressedRatingBar: (i){},
                      selectedIndex: 0,
                      context: context,
                      textController: TextEditingController(),
                      onPressed: () {},
                      text: 'You rated Zübeyir X 5 star',
                    ),
                  );
                },
                child: Text('CommentBottomSheetBar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  CommentModel model = CommentModel(
                    commentorUserId: userId,
                    comment: 'test',
                    point: 5,
                  );
                  await CommentService.instance.comment(model);
                },
                child: Text('Comment'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  await CommentService.instance.getComment(userId);
                },
                child: Text('My Comment'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driverActive(model);
                },
                child: Text('Driver Active'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driveCancel(model);
                },
                child: Text('Drive Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(driverId: userId);
                  await DriveService.instance.driverPassive(model);
                },
                child: Text('Driver Passive'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  var now = DateTime.now();
                  var timeTo =
                      DateTime(now.year, now.month, now.day, 23, 23, 23);
                  DriveModel model = DriveModel(
                    driverId: userId,
                    to: 'id',
                    timeFrom: now.toString(),
                    timeTo: timeTo.toString(),
                  );
                  await DriveService.instance.driveMatched(model);
                },
                child: Text('Driver Matched'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(
                    callerId: userId,
                  );
                  await DriveService.instance.driveConfirmed(model);
                },
                child: Text('Driver Confirmed'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  DriveModel model = DriveModel(
                    driverId: userId,
                  );
                  await DriveService.instance.driving(model);
                },
                child: Text('Driving'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await SecurityService.intance.callerCode('sadsda');
                },
                child: Text('Caller Code'),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: context.responsiveHeight(400),
                              bottom: context.responsiveHeight(16),
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
                                    Text('220₺',
                                        style: context
                                            .textStyle.titleXlargeRegular),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppThemes.warningYellow700,
                                        ),
                                        Text(
                                          '4.9',
                                          style: context
                                              .textStyle.bodySmallRegular,
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
                                      'test',
                                      'test2',
                                    ),
                                    SizedBox(
                                      height: context.responsiveHeight(29),
                                    ),
                                    _buildLocationRow(
                                      context,
                                      'map4',
                                      'test',
                                      'test2',
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SecondaryButton(
                                          width: context.responsiveWidth(160),
                                          text: 'Cancel',
                                          context: context,
                                          onPressed: () {},
                                        ),
                                        PrimaryButton(
                                          width: context.responsiveWidth(160),
                                          text: 'Accept',
                                          context: context,
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Text('Driver dialog')),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: HexColor('#469AD8'),
                  maximumSize: const Size(150, 40),
                ),
                icon: const Icon(Icons.navigation),
                label: Text(
                  'navigate'.tr(),
                  style: context.textStyle.subheadSmallRegular,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (_) {
                      return DriveBottomSheet(
                        context: context,
                        pickingUpText: 'pickingUpText',
                        imagePath: 'https://via.placeholder.com/54x59',
                        customerName: 'customerName',
                        startText: 'startText',
                        location1Text: 'location1Text',
                        location1TextTitle: 'location1TextTitle',
                        location2Text: 'location2Text',
                        location2TextTitle: 'location2TextTitle',
                        onPressed: () {},
                      );
                    },
                  );
                },
                child: Text('Drive bottom sheet bar 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (_) {
                      return Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: DriveBottomSheet(
                          context: context,
                          height: 0.60,
                          buttonText: 'startTheTrip'.tr(),
                          pickingUpText: 'pickingUpText',
                          imagePath: 'https://via.placeholder.com/54x59',
                          customerName: 'customerName',
                          startText: 'startText',
                          location1Text: 'location1Text',
                          location1TextTitle: 'location1TextTitle',
                          location2Text: 'location2Text',
                          location2TextTitle: 'location2TextTitle',
                          onPressed: () {},
                        ),
                      );
                    },
                  );
                },
                child: Text('Drive bottom sheet bar 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (_) {
                      return Container(
                        height: context.customeHeight(0.12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.close),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.responsiveWidth(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'pickingUpText',
                                    style: context.textStyle.subheadLargeMedium,
                                  ),
                                  Text(
                                    'pickingUpText',
                                    style: context.textStyle.subheadLargeMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: context.responsiveHeight(8),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text('Drive bottom sheet bar short'),
              ),
            ],
          ),
        ),
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
