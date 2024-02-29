import 'dart:async';
import 'dart:io';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shazy/pages/home/driver_home/driver_controller/driver_controller.dart';
import 'package:shazy/widgets/dialogs/drive_dialog.dart';

import '../../../core/assistants/asistant_methods.dart';
import '../../../core/base/app_info.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../core/init/network/network_manager.dart';
import '../../../models/comment/comment_model.dart';
import '../../../models/drive/drive_model.dart';
import '../../../models/user/user_profile_model.dart';
import '../../../services/comment/comment_service.dart';
import '../../../services/payment/payment_service.dart';
import '../../../services/user/user_service.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/extensions/context_extension.dart';
import '../../../widgets/buttons/icon_button.dart';

import '../../../widgets/dialogs/congratulation_dialog.dart';
import '../../../widgets/dialogs/security_code_dialog.dart';
import '../../../widgets/drawer/custom_drawer.dart';
import '../../../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import '../../../widgets/modal_bottom_sheet/drive_bottom_sheet.dart';
import '../../history/controller/history_upcoming_controller.dart';
import '../home_screen_transport.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  static String stat = '';

  //static bool allowNavigation = true;

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with TickerProviderStateMixin {
  // status kontrol flagları
  String currentStatus = '';
  bool isMatched = true;
  bool isComment = true;

  late double callerAveragePoint = 0.0;
  late String callerId = '';
  late String callerName = '';
  late String callerPicturePath = '';
  late String callerSurname = '';
  DriveModel driveDetailsInfo = DriveModel();
  late String driverId = '';
  late double driverLatitude;
  late double driverLongitude;
  int flag = 0;
  late double fromLatitude;
  late double fromLongitude;
  String humanReadableAddress = '';
  List<LatLng> pLineCoOrdinatesList = [];
  List<LatLng> pLineCoOrdinatesList2 = [];
  late String requestId2 = '';
  late String apiUrl2 = '';
  late double toLatitude;
  late double toLongitude;
  late int totalPayment = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.802516, 29.439794),
    zoom: 14.4746,
  );

  List<AnimationController> _bottomSheetControllers = [];
  final TextEditingController _commentTextController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _controllerComment = HistoryUpcomingController();
  final DriverController _driverController = DriverController();
  late int _duraitonKmCallertoDestinationValue = 0;
  final Duration _duration = const Duration(milliseconds: 500);
  late String _durationKmCallerToDestination = '';
  late String _durationKmDriverToCaller = '';
  late String _durationTimeCallerToDestination = '';
  late String _durationTimeDriverToCaller = '';
  late String _endAddressCallerToDestination = '';
  late String _endAddressDriverToCaller = '';
  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  final Set<Polyline> _polyLineSet = {};
  late String _startAddressCallerToDestination;
  late String _startAddressDriverToCaller;
  late Timer _timerIsMatched;
  late Timer _timerSendRequest;
  late Timer _canceledTimer;
  List<Tween<Offset>> _tweens = [];
  Position? _userCurrentPosition;

  @override
  void dispose() {
    // Timer'ı iptal et
    if (_timerIsMatched.isActive) {
      _timerIsMatched.cancel();
    }
    if (_canceledTimer.isActive) {
      _canceledTimer.cancel();
    }
    if (_timerSendRequest.isActive) {
      _timerSendRequest.cancel();
    }

    _disposeBottomSheetControllers();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initializeBottomSheetControllers();

    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
      (value) {
        _mapTheme = value;
      },
    );
    _timerIsMatched = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Her 5 saniyede bir istek gönder
      sendRequestMatched();
    });

    _driverController.active(context);
  }

  Future<void> sendRequestCanceled() async {
    try {
      apiUrl2 = "/drive-request/$requestId2";

      var requestResponse = await NetworkManager.instance.get(apiUrl2);

      currentStatus = requestResponse["status"];

      if (currentStatus == 'canceled') {
        HomeScreenTransport.allowNavigation = true;
        _canceledTimer.cancel();
        //drawPolyLineFromOriginToDestination();
        NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {}
  }

  Future<void> sendRequestMatched() async {
    try {
      driverId = await SessionManager().get('id');
      String apiUrl = "/drive-request/driver/$driverId/matched";
      var requestId = await NetworkManager.instance.get(apiUrl);

      requestId2 = requestId[0]["id"];
      callerId = requestId[0]["caller_id"];

      UserProfileModel? userProfile = await UserService.instance.getAnotherUser(callerId);
      callerAveragePoint = userProfile!.averagePoint!;
      callerName = userProfile.userModel!.name!;
      callerSurname = userProfile.userModel!.surname!;
      callerPicturePath = userProfile.profilePicturePath!;

      apiUrl2 = "/drive-request/$requestId2";
      _timerIsMatched.cancel();
      _timerSendRequest = Timer.periodic(const Duration(seconds: 10), (timer) {
        // Her 5 saniyede bir istek gönder
        sendRequest();
      });
    } catch (e) {}
  }

  Future<void> sendRequest() async {
    try {
      var requestResponse = await NetworkManager.instance.get(apiUrl2);

      if (requestResponse != null) {
        currentStatus = requestResponse["status"];
        //String driverId = requestResponse["driver_id"];
        driverLatitude = double.parse(requestResponse["driver_lat"]);
        driverLongitude = double.parse(requestResponse["driver_lang"]);
        fromLatitude = double.parse(requestResponse["from_lat"]);
        fromLongitude = double.parse(requestResponse["from_lang"]);
        toLatitude = double.parse(requestResponse["to_lat"]);
        toLongitude = double.parse(requestResponse["to_lang"]);

        if (currentStatus == 'matched' && isMatched) {
          HomeScreenTransport.allowNavigation = false;
          isMatched = false;
          //_timer.cancel();
          drawPolyLineFromOriginToDestination();
          _canceledTimer = Timer.periodic(Duration(seconds: 10), (timer) {
            // Her 10 saniyede bir istek gönder
            sendRequestCanceled();
          });
        } else if (currentStatus == 'comment' && isComment) {
          isComment = false;
          _timerIsMatched.cancel();
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                context: context,
                text1: 'The funds have been successfully transferred to $callerName $callerSurname.',
                title: 'Payment Success',
                onTap: () async {
                  NavigationManager.instance.navigationToPop();
                  _bottomSheetControllers[1].reverse();
                  showModalBottomSheet(
                    isDismissible: false,
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
                        selectedIndex: _controllerComment.starSelectedIndex,
                        context: context,
                        textController: _commentTextController,
                        onPressed: () {
                          sendComment(_commentTextController.text, _controllerComment.starSelectedIndex);
                          setState(() {
                            HomeScreenTransport.allowNavigation = true;
                            _canceledTimer.cancel();
                          });

                          NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
                        },
                        onPressedRatingBar: _controllerComment.changeStarSelectedIndex,
                        text: '${'youRated'.tr()} $callerName ${' ${_controllerComment.starSelectedIndex}'} ${'star'.tr()}',
                      );
                    }),
                  );
                },
                widget: Column(
                  children: [
                    Text(
                      'amount'.tr(),
                      style: context.textStyle.labelSmallMedium.copyWith(
                        color: HexColor("#5A5A5A"),
                      ),
                    ),
                    Text(
                      '${totalPayment.toString()}₺',
                      style: context.textStyle.titleXlargeRegular.copyWith(
                        color: HexColor("#2A2A2A"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } else {
        // Handle the case where the response is null or not as expected
        print("Error Occurred, Failed. No Response.");
      }
    } catch (e) {
      // Handle exceptions or errors here
      print("Error Occurred, Failed. Exception: $e");
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(_userCurrentPosition!.latitude, _userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    _newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(_userCurrentPosition!, context);
    }
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    //kullanıcı konum alma lazım olursa diye****
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _userCurrentPosition = cPosition;

    var driverOriginLatLng = LatLng(_userCurrentPosition!.latitude, _userCurrentPosition!.longitude);
    var originLatLng = LatLng(fromLatitude, fromLongitude);
    var destinationLatLng = LatLng(toLatitude, toLongitude);

    var driverDirectionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(driverOriginLatLng, originLatLng);

    _durationKmDriverToCaller = driverDirectionDetailsInfo!.distance_text.toString();
    _durationTimeDriverToCaller = driverDirectionDetailsInfo.duration_text.toString();
    _startAddressDriverToCaller = driverDirectionDetailsInfo.start_address.toString();
    _endAddressDriverToCaller = driverDirectionDetailsInfo.end_address.toString();

    PolylinePoints pPointsDriver = PolylinePoints();
    List<PointLatLng> driverDecodedPolyLinePointsResultList = pPointsDriver.decodePolyline(driverDirectionDetailsInfo!.e_pointsDrive!);

    //pLineCoOrdinatesList.clear();

    if (driverDecodedPolyLinePointsResultList.isNotEmpty) {
      driverDecodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList2.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    //pLineCoOrdinatesList.clear();
    setState(() {
      Polyline polyline2 = Polyline(
        color: Colors.red,
        polylineId: const PolylineId("PolylineID2"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList2,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLineSet.add(polyline2);
    });

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    _durationKmCallerToDestination = directionDetailsInfo!.distance_text.toString();
    _durationTimeCallerToDestination = directionDetailsInfo.duration_text.toString();
    _startAddressCallerToDestination = directionDetailsInfo.start_address.toString();
    _endAddressCallerToDestination = directionDetailsInfo.end_address.toString();
    _duraitonKmCallertoDestinationValue = directionDetailsInfo.distance_value!;

    totalPayment = ((_duraitonKmCallertoDestinationValue / 1000) * 35).toInt();

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    //pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    //pLineCoOrdinatesList.clear();

    //_polyLineSet.clear();

    //_durationKm = directionDetailsInfo.distance_text.toString();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLineSet.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    _newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: 'originPosition.locationName', snippet: directionDetailsInfo.duration_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: 'destinationPosition.locationName', snippet: directionDetailsInfo.distance_text.toString()),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      _markersSet.add(originMarker);
      _markersSet.add(destinationMarker);
    });

    // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DriverDialog(
        context: context,
        price: '$totalPayment₺',
        star: callerAveragePoint.toString(),
        location1TextTitle: "$_durationTimeDriverToCaller ($_durationKmDriverToCaller) away",
        location1Text: _endAddressDriverToCaller.length > 36 ? "${_endAddressDriverToCaller.substring(0, 36)}..." : _endAddressDriverToCaller,
        location2TextTitle: "$_durationTimeCallerToDestination ($_durationKmCallerToDestination) trip",
        location2Text: _endAddressCallerToDestination.length > 36 ? "${_endAddressCallerToDestination.substring(0, 36)}..." : _endAddressCallerToDestination,
        cancelOnPressed: () async {
          await _driverController.driveCancel(context);
          setState(() {
            _markersSet.clear();
            _polyLineSet.clear();
          });
          NavigationManager.instance.navigationToPageClear(NavigationConstant.cancelDrive);
        },
        acceptOnPressed: () async {
          var userId = await SessionManager().get('id');
          DriveModel model = DriveModel(driverId: userId);
          if (context.mounted) {
            await _driverController.driverAccept(context, model);
          }
          _showDriverBottomSheet(0);
        },
      ),
    );
  }

  Future<void> sendComment(String comment, int index) async {
    var model = CommentModel(comment: comment, point: index.toDouble());
    model.commentorUserId = driverId;
    var response = await CommentService.instance.comment(model, 'driver');
    // NavigationManager.instance.navigationToPop();
    if (response != null) {}
  }

  void _disposeBottomSheetControllers() {
    for (var controller in _bottomSheetControllers) {
      controller.dispose();
    }
  }

  void _initializeBottomSheetControllers() {
    _bottomSheetControllers = [
      AnimationController(vsync: this, duration: _duration),
      AnimationController(vsync: this, duration: _duration),
    ];

    _tweens = [
      Tween(begin: const Offset(0, 1), end: Offset(0, 0)),
      Tween(begin: const Offset(0, 1), end: Offset(0, 0)),
    ];
  }

  GoogleMap _buildGoogleMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _newGoogleMapController = controller;
        if (!context.isLight) {
          setState(() {
            controller.setMapStyle(_mapTheme);
          });
        }
        locateUserPosition();
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: Platform.isIOS ? true : false,
      zoomControlsEnabled: false,
      polylines: _polyLineSet,
      markers: _markersSet,
    );
  }

  void _showDriverBottomSheet(int index) {
    if (mounted) {
      var controller = _bottomSheetControllers[index];
      if (controller.isDismissed) {
        controller.forward();
      } else if (controller.isCompleted) {
        controller.reverse();
      }
    }
  }

  Widget _buildDriverBottomSheetContent(int index, BuildContext context) {
    double size = context.height < 620 ? 0.6 : 0.54;

    return SizedBox.expand(
      child: SlideTransition(
        position: _tweens[index].animate(_bottomSheetControllers[index]),
        child: DraggableScrollableSheet(
          initialChildSize: size,
          minChildSize: 0.1,
          maxChildSize: size,
          builder: (BuildContext context, ScrollController scrollController) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: DriveBottomSheet(
              height: size,
              buttonTextStart: index == 0 ? 'startTheTrip'.tr() : 'finishTheTrip'.tr(),
              context: context,
              pickingUpText: index == 0 ? 'pickingUpText'.tr() : 'goingToDestination',
              imagePath: "https://randomuser.me/api/portraits/men/93.jpg" /*'$baseUrl/$callerAvaragePoint'*/,
              customerName: '$callerName $callerSurname',
              startText: callerAveragePoint.toString(),
              location1Text: humanReadableAddress.length > 36 ? "${humanReadableAddress.substring(0, 36)}..." : humanReadableAddress,
              location1TextTitle: 'currentLocation'.tr(),
              location2Text:
                  _endAddressCallerToDestination.length > 36 ? "${_endAddressCallerToDestination.substring(0, 36)}..." : _endAddressCallerToDestination,
              location2TextTitle: "$_durationTimeCallerToDestination ($_durationKmCallerToDestination) trip",
              showSecondaryButton: index == 0 ? true : false, // Eğer index 0 ise showSecondaryButton true olacak
              onPressedStart: () async {
                if (index == 0) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SecurityCodeDialog(
                        context: context,
                        onDialogClosed: () {
                          _bottomSheetControllers[0].reverse();
                        },
                        showDialog: () {
                          _showDriverBottomSheet(1);
                        },
                      );
                    },
                  );
                } else {
                  await PaymentService.instance.waitPayment(driverId);
                }
              },
              onPressedCancel: index == 0
                  ? () async {
                      NavigationManager.instance.navigationToPage(NavigationConstant.cancelRide, args: driverId);
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  CustomIconButton _buildRightTopButton(BuildContext context) => _driverController.driverActive
      ? _buildCustomIconButton(false, Icons.close, () {
          _driverController.driverPassive(context);
        })
      : _buildCustomIconButton(false, Icons.notifications_none_outlined, () {
          NavigationManager.instance.navigationToPage(NavigationConstant.notification);
        });

  Widget _buildTopLeftButton(BuildContext context) {
    return _driverController.driverActive
        ? _buildCustomIconButton(true, Icons.menu, () {
            // TODO: test amaçlı yapılmış olup kaldırılacaktır!
          })
        : SizedBox();
  }

  CustomIconButton _buildCustomIconButton(bool isLeft, IconData icon, VoidCallback onPressed) => CustomIconButton(
        context: context,
        top: context.responsiveHeight(60),
        left: isLeft ? context.responsiveWidth(15) : null,
        right: !isLeft ? context.responsiveWidth(15) : null,
        height: context.responsiveHeight(34),
        width: context.responsiveWidth(34),
        icon: icon,
        color: Colors.black,
        size: 18,
        onPressed: onPressed,
      );

  Padding _buildBottomOfBody(BuildContext context, double keyboardSize) {
    return Padding(
      // sayfanın alt kısmı
      padding: EdgeInsets.only(
        top: context.responsiveHeight(480) - keyboardSize + (keyboardSize != 0 ? context.responsiveHeight(150) : 0),
        right: context.responsiveWidth(15),
        left: context.responsiveWidth(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          true
              ? SizedBox()
              : const Center(
                  // TODO: UI burası değişebilir
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  Padding _buildGoogleMapsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(630),
        left: context.responsiveWidth(245),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          if (DriverHomePage.stat == 'driving') {
            MapsLauncher.launchCoordinates(toLatitude, toLongitude, 'Yol Tarifi');
          } else if (driveDetailsInfo.status == 'accept') {
            MapsLauncher.launchCoordinates(fromLatitude, fromLongitude, 'Yol Tarifi');
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: HexColor('#469AD8'),
          maximumSize: const Size(150, 40),
        ),
        icon: const Icon(Icons.navigation, color: Colors.white),
        label: Text(
          'navigate'.tr(),
          style: context.textStyle.subheadSmallRegular.copyWith(color: Colors.white, fontSize: context.responsiveFont(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppInfo>(context).userDropOffLocation != null && flag == 0) {
      drawPolyLineFromOriginToDestination();
      flag = 1;
    } else {
      print('işlem yapılmadı');
    }
    double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Observer(builder: (_) {
          return Stack(
            children: [
              _buildGoogleMap(context),
              if (HomeScreenTransport.allowNavigation) _buildTopLeftButton(context),
              if (HomeScreenTransport.allowNavigation) _buildRightTopButton(context),
              _buildBottomOfBody(context, keyboardSize),
              _buildGoogleMapsButton(context),
              _buildDriverBottomSheetContent(0, context),
              _buildDriverBottomSheetContent(1, context),
            ],
          );
        }),
      ),
      drawer: CustomDrawer(
        context: context,
        email: "deneme@gmail.com",
        name: "Test",
      ),
    );
  }
}
