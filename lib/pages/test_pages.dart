import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/pages/payment/controller/payment_controller.dart';
import 'package:shazy/services/payment/payment_service.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/dialogs/drive_dialog.dart';
import 'package:shazy/widgets/dialogs/search_driver_dialog.dart';
import 'package:shazy/widgets/divider/counter_divider.dart';
import 'package:shazy/widgets/modal_bottom_sheet/drive_bottom_sheet.dart';
import '../core/init/firebase/firebase_notification_manager.dart';
import '../core/init/models/caller_home_directions.dart';
import '../core/init/models/directions.dart';
import '../core/init/models/driver_home_directions.dart';
import '../core/init/navigation/navigation_manager.dart';
import '../core/init/network/network_manager.dart';
import '../models/comment/comment_model.dart';
import '../models/drive/drive_model.dart';
import '../models/payment/payment_model.dart';
import '../models/security/security_model.dart';
import '../services/comment/comment_service.dart';
import '../services/drive/drive_service.dart';
import '../services/security/security_service.dart';
import '../utils/constants/navigation_constant.dart';
import '../utils/extensions/context_extension.dart';
import '../utils/helper/helper_functions.dart';
import '../utils/theme/themes.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/containers/payment_method_container.dart';
import '../widgets/dialogs/congratulation_dialog.dart';
import '../widgets/dialogs/error_dialog.dart';
import '../widgets/icons/circular_svg_icon.dart';
import '../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import '../widgets/rating_bars/star_rating_bar.dart';
import '../widgets/textfields/otp_text_form_field.dart';
import '../core/init/cache/cache_manager.dart';
import '../models/user/user_model.dart';
import '../services/history/history_service.dart';
import '../services/user/user_service.dart';
import '../widgets/padding/base_padding.dart';
import 'package:image/image.dart' as img;

// TODO: End pointleri test etmek için olan sayfa proda çıkmadan kaldırılacak
class TestPage extends StatefulWidget {
  TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  String _imagePath = '';
  final _key = GlobalKey();
  final _picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double _size = 0;
  final Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  void _showDriverDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DriverDialog(
        context: context,
        price: '220₺',
        star: '4.9',
        location1TextTitle: 'kocaeli',
        location1Text: 'İzmit',
        location2TextTitle: 'Bursa',
        location2Text: 'Demirtaş Paşa',
        cancelOnPressed: () {},
        acceptOnPressed: () {},
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

  Future<void> _addImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        // Resmi byte array olarak oku
        Uint8List imageBytes = await imageFile.readAsBytes();

        // Resmi image paketi ile yükle
        img.Image? image = img.decodeImage(imageBytes);

        if (image != null) {
          // Resim boyutunu küçült
          img.Image resizedImage =
              img.copyResize(image, width: 400); // Genişliği 800 piksel yapın

          // Küçültülmüş resmi yeniden byte array olarak al
          Uint8List resizedImageBytes =
              Uint8List.fromList(img.encodeJpg(resizedImage));

          // Base64 string oluştur
          String base64String =
              base64.normalize(base64Encode(resizedImageBytes));
          log(base64String.length.toString());
          log(base64String);
          setState(() {
            _imagePath = base64String;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String _truncateString(String input, int length) {
    if (input.length <= length) {
      return input;
    } else {
      return input.substring(0, length);
    }
  }

  Future<void> updateUserProfile(
      BuildContext context, UserProfileModel model) async {
    try {
      String? email = await CacheManager.instance.getData('user', 'email');
      var id = await SessionManager().get('id');
      String? responseRegiserControl;
      if (email != model.userModel?.email) {
        responseRegiserControl = await UserService.instance
            .registerControl(UserModel(email: model.userModel?.email));
        if (responseRegiserControl != null &&
            responseRegiserControl != '200' &&
            context.mounted) {
          HelperFunctions.instance.showErrorDialog(
              context, responseRegiserControl, 'backHome'.tr(), () {
            NavigationManager.instance
                .navigationToPageClear(NavigationConstant.homePage);
          });
        }
      }
      var responseUpdateUser = await NetworkManager.instance
          .put('/user/$id', model: model.userModel);
      CacheManager.instance
          .putData('user', 'email', model.userModel!.email.toString());
      CacheManager.instance.putData('user', 'name',
          '${model.userModel?.name} ${model.userModel?.surname.toString()[0]}.');

      var responseUpdateUserProfile =
          await NetworkManager.instance.put('/user-profile/$id', model: model);
      if (context.mounted) {}
      NavigationManager.instance.navigationToPop();
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'updateProfileError'.tr(), 'backHome'.tr(), () {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        });
      }
    }
  }

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
                  await _addImage();

                  /*if (_imagePath == '') {
                    await _addImage();
                  }
                  var model = UserProfileModel(
                      userModel: UserModel(
                          name: 'test',
                          surname: 'test',
                          email: 'halil@gmail.com'),
                      profilePicturePath: base64.normalize(_imagePath));
                  var id = await SessionManager().get('id');
                  log(base64.normalize(_imagePath));
                  await NetworkManager.instance
                      .put2('/user-profile/$id', model.toJson(), data: model);*/
                },
                child: Text('update profile page'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var token = await FirebaseNotificationManager
                      .instance.notificationToken;
                  Map<String, dynamic> request = {
                    'registrationToken': token,
                    'notificationMessage': 'test',
                  };
                  await NetworkManager.instance
                      .post('/send-notification', data: request);
                },
                child: Text('Push notification'),
              ),
              ElevatedButton(
                onPressed: () async {
                  PaymentController paymentController = PaymentController();
                  await paymentController.pay('222', context);
                },
                child: Text('Comment bottom sheet payment'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    isDismissible: false,
                    isScrollControlled: true,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    context: context,
                    builder: (_) => CommentBottomSheet(
                      selectedIndex: 0,
                      context: context,
                      textController: TextEditingController(),
                      onPressed: () async {
                        NavigationManager.instance
                            .navigationToPageClear(NavigationConstant.homePage);
                      },
                      onPressedRatingBar: (index) {},
                      text: 'test test',
                    ),
                  );
                },
                child: Text('Comment bottom sheet'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DriverHomeDirections directions = DriverHomeDirections();
                  var box = await Hive.openBox('driver_directions');
                  var response = await box.get('driver_directions');
                  directions = directions.fromJson(response);
                },
                child: Text('driver cache directions'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Directions directions = Directions();
                  var box = await Hive.openBox('directions');
                  var response = await box.get('directions');
                  directions = directions.fromJson(response);
                  log(directions.endLocationLongitude.toString());
                },
                child: Text('cache directions'),
              ),
              ElevatedButton(
                onPressed: () async {
                  CallerHomeDirections callerHomeDirections =
                      CallerHomeDirections();
                  var box = await Hive.openBox('caller_directions');
                  var response = await box.get('caller_directions');
                  callerHomeDirections =
                      callerHomeDirections.fromJson(response);
                },
                child: Text('caller cache directions'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await PaymentService.instance
                      .waitPayment('9b1ccfb8-0c72-4af1-8e03-59c6fc5612de');
                },
                child: Text('WaitPayment'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ErrorDialog(
                      context: context,
                      title: 'paymentSuccess'.tr(),
                      buttonText: 'test test',
                      onPressed: () {},
                    ),
                  );
                },
                child: Text('error dialog'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var userId = await SessionManager().get('id');
                  SecurityModel model =
                      SecurityModel(driverId: userId, securityCode: '64542');
                  await SecurityService.intance.securityCodeMatch(model);
                },
                child: Text('securi code eşleşme'),
              ),
              ElevatedButton(
                onPressed: () {
                  NavigationManager.instance
                      .navigationToPage(NavigationConstant.cancelDrive);
                },
                child: Text('cancel drive Test'),
              ),
              ElevatedButton(
                onPressed: () async {
                  PaymentModel model = PaymentModel(
                      cardHolderName: 'Muhammed Akkaynak',
                      cardNumber: '5127541122223332',
                      month: '12',
                      year: '2025',
                      cvv: '111',
                      uid: '9b39e1cf-d39c-4aaf-866e-1d0a05848735',
                      amount: '10');
                  var response = await PaymentService.instance.pay(model);
                },
                child: const Text('Pay'),
              ),
              ElevatedButton(
                onPressed: () {
                  double widgetWidth = _key.currentContext?.size?.width ?? 0;
                  double halfWidgetWidth = widgetWidth / 2;
                  double indent = halfWidgetWidth / 30;
                  int seconds = 0;
                  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {
                      _size = indent * seconds;
                    });
                    seconds++;
                    print('$seconds:$_size');
                  });
                  Future.delayed(Duration(seconds: 30), () {
                    timer.cancel();
                    setState(() {
                      _size = halfWidgetWidth;
                    });
                  });
                },
                child: Text('Genel Test'),
              ),
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                      email: 'fatihdriver@gmail.com', phone: '999999');
                  var response =
                      await UserService.instance.registerControl(model);
                  print('-------');
                  print(response);
                },
                child: Text('RegisterControl'),
              ),
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
                  //CacheManager.instance.clearAll('user');
                  //CacheManager.instance.clearAll('card');
                  CacheManager.instance.clearAll('directions');
                  CacheManager.instance.clearAll('caller_directions');
                  CacheManager.instance.clearAll('driver_directions');
                },
                child: Text('cache delete'),
              ),
              ElevatedButton(
                onPressed: () {
                  UserService.instance.logout();
                },
                child: Text('logout'),
              ),
              ElevatedButton(
                onPressed: () async {
                  UserModel model = UserModel(
                    email: 'haliltest@gmail.com',
                    password: 'Sivas58',
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
                      onPressedRatingBar: (i) {},
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
                  await CommentService.instance.comment(model, 'caller');
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
                  DriveModel model = DriveModel(
                      driverId: userId, driverLat: 40.0, driverLang: 28.0);
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
                onPressed: () {
                  MapsLauncher.launchCoordinates(
                      37.4220041, -122.0862462, 'Google Headquarters are here');
                },
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
                        onPressedStart: () {},
                        showSecondaryButton: true,
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
                          buttonTextStart: 'startTheTrip'.tr(),
                          pickingUpText: 'pickingUpText',
                          imagePath: 'https://via.placeholder.com/54x59',
                          customerName: 'customerName',
                          startText: 'startText',
                          location1Text: 'location1Text',
                          location1TextTitle: 'location1TextTitle',
                          location2Text: 'location2Text',
                          location2TextTitle: 'location2TextTitle',
                          onPressedStart: () {},
                          showSecondaryButton: true,
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
              ElevatedButton(
                onPressed: () {
                  _showDriverDialog(context);
                },
                child: Text('Driver dialog2'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.isDismissed)
                    _controller.forward();
                  else if (_controller.isCompleted) _controller.reverse();

                  /*DraggableScrollableSheet(
                    builder: (_, controller) => DriveBottomSheet(
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
                    ),
                  );*/
                  /*showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (_) {
                      return DraggableScrollableSheet(
                          builder: (context, controller) {
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
                      });
                    },
                  ); */
                },
                child:
                    Text('Drive bottom sheet bar (Elifin dediği gibi çalışan)'),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SearchDriverDialog(
                              context: context, onPressed: () {});
                        });
                  },
                  child: Text('SearchDriverDialog')),
              SizedBox(
                height: context.height,
                child: SlideTransition(
                  position: _tween.animate(_controller),
                  child: DraggableScrollableSheet(
                    minChildSize: 0.1,
                    maxChildSize: 0.7,
                    initialChildSize: 0.1,
                    builder: (BuildContext context,
                            ScrollController scrollController) =>
                        DriveBottomSheet(
                      context: context,
                      pickingUpText: 'pickingUpText',
                      imagePath: 'https://via.placeholder.com/54x59',
                      customerName: 'customerName',
                      startText: 'startText',
                      location1Text: 'location1Text',
                      location1TextTitle: 'location1TextTitle',
                      location2Text: 'location2Text',
                      location2TextTitle: 'location2TextTitle',
                      onPressedStart: () {},
                      showSecondaryButton: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
