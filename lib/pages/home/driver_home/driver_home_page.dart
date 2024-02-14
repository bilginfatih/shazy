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

class _DriverHomePageState extends State<DriverHomePage>
    with TickerProviderStateMixin {
  late double driverLatitude;
  late double driverLongitude;
  late double fromLatitude;
  late double fromLongitude;
  String humanReadableAddress = '';
  List<LatLng> pLineCoOrdinatesList = [];
  List<LatLng> pLineCoOrdinatesList2 = [];
  late double toLatitude;
  late double toLongitude;

  late String requestId2 = '';

  final _controllerComment = HistoryUpcomingController();
  final TextEditingController _commentTextController = TextEditingController();

  DriveModel driveDetailsInfo = DriveModel();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<AnimationController> _bottomSheetControllers = [];
  List<Tween<Offset>> _tweens = [];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final DriverController _driverController = DriverController();

  final Duration _duration = const Duration(milliseconds: 500);

  late String _durationKmCallerToDestination = '';
  late int _duraitonKmCallertoDestinationValue = 0;
  late String _durationKmDriverToCaller = '';
  late String _durationTimeCallerToDestination = '';
  late String _durationTimeDriverToCaller = '';
  late String _endAddressCallerToDestination = '';
  late String _endAddressDriverToCaller = '';
  late int totalPaymant = 0;

  late double callerAvaragePoint = 0.0;
  late String callerName = '';
  late String callerSurname = '';
  late String callerPicturePath = '';
  late String callerId = '';
  late String driverId = '';

  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  final Set<Polyline> _polyLineSet = {};

  late String _startAddressCallerToDestination;
  late String _startAddressDriverToCaller;

  late Timer _timer;
  late Timer _canceledTimer;

  int flag = 0;

  Position? _userCurrentPosition;

  @override
  void dispose() {
    // Timer'ı iptal et
    if (_timer.isActive) {
      _timer.cancel();
    }
    if (_canceledTimer.isActive) {
      _canceledTimer.cancel();
    }

    _disposeBottomSheetControllers();
    super.dispose();
  }

  void _disposeBottomSheetControllers() {
    for (var controller in _bottomSheetControllers) {
      controller.dispose();
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeBottomSheetControllers();

    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night_theme.json')
        .then(
      (value) {
        _mapTheme = value;
      },
    );
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Her 5 saniyede bir istek gönder
      sendRequest();
    });

    _driverController.active(context);
  }

  Future<void> sendRequestCanceled() async {
    try {
      String apiUrl = "/drive-request/$requestId2";

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      driveDetailsInfo.status = requestResponse["status"];

      if (driveDetailsInfo.status == 'canceled') {
        HomeScreenTransport.allowNavigation = true;
        _canceledTimer.cancel();
        //drawPolyLineFromOriginToDestination();
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {}
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

  Future<void> sendRequest() async {
    try {
      String userId = await SessionManager().get('id');
      String id = "/drive-request/driver/$userId/matched";
      var requestId = await NetworkManager.instance.get(id);

      var statusId = requestId[0]["id"];

      callerId = requestId[0]["caller_id"];
      driverId = requestId[0]["driver_id"];

      UserProfileModel? userProfile =
          await UserService.instance.getAnotherUser(callerId);
      callerAvaragePoint = userProfile!.avaragePoint!;
      callerName = userProfile.userModel!.name!;
      callerSurname = userProfile.userModel!.surname!;
      callerPicturePath = userProfile.profilePicturePath!;

      requestId2 = statusId;
      String apiUrl = "/drive-request/$requestId2";

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      if (requestResponse != null) {
        driveDetailsInfo.status = requestResponse["status"];
        //String driverId = requestResponse["driver_id"];
        driverLatitude = double.parse(requestResponse["driver_lat"]);
        driverLongitude = double.parse(requestResponse["driver_lang"]);
        fromLatitude = double.parse(requestResponse["from_lat"]);
        fromLongitude = double.parse(requestResponse["from_lang"]);
        toLatitude = double.parse(requestResponse["to_lat"]);
        toLongitude = double.parse(requestResponse["to_lang"]);

        if (driveDetailsInfo.status == 'matched') {
          HomeScreenTransport.allowNavigation = false;
          _timer.cancel();
          drawPolyLineFromOriginToDestination();
          _canceledTimer = Timer.periodic(Duration(seconds: 10), (timer) {
            // Her 5 saniyede bir istek gönder
            sendRequestCanceled();
          });
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
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(_userCurrentPosition!.latitude, _userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    _newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      humanReadableAddress =
          await AssistantMethods.searchAddressForGeographicCoOrdinates(
              _userCurrentPosition!, context);
    }
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    //kullanıcı konum alma lazım olursa diye****
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _userCurrentPosition = cPosition;

    var driverOriginLatLng =
        LatLng(_userCurrentPosition!.latitude, _userCurrentPosition!.longitude);
    var originLatLng = LatLng(fromLatitude, fromLongitude);
    var destinationLatLng = LatLng(toLatitude, toLongitude);

    var driverDirectionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            driverOriginLatLng, originLatLng);

    _durationKmDriverToCaller =
        driverDirectionDetailsInfo!.distance_text.toString();
    _durationTimeDriverToCaller =
        driverDirectionDetailsInfo.duration_text.toString();
    _startAddressDriverToCaller =
        driverDirectionDetailsInfo.start_address.toString();
    _endAddressDriverToCaller =
        driverDirectionDetailsInfo.end_address.toString();

    PolylinePoints pPointsDriver = PolylinePoints();
    List<PointLatLng> driverDecodedPolyLinePointsResultList = pPointsDriver
        .decodePolyline(driverDirectionDetailsInfo!.e_pointsDrive!);

    //pLineCoOrdinatesList.clear();

    if (driverDecodedPolyLinePointsResultList.isNotEmpty) {
      driverDecodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList2
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
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

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    _durationKmCallerToDestination =
        directionDetailsInfo!.distance_text.toString();
    _durationTimeCallerToDestination =
        directionDetailsInfo.duration_text.toString();
    _startAddressCallerToDestination =
        directionDetailsInfo.start_address.toString();
    _endAddressCallerToDestination =
        directionDetailsInfo.end_address.toString();
    _duraitonKmCallertoDestinationValue = directionDetailsInfo.distance_value!;

    totalPaymant = ((_duraitonKmCallertoDestinationValue / 1000) * 35).toInt();

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    //pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
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
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
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
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    _newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(
          title: 'originPosition.locationName',
          snippet: directionDetailsInfo.duration_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: 'destinationPosition.locationName',
          snippet: directionDetailsInfo.distance_text.toString()),
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
        price: '$totalPaymant₺',
        star: callerAvaragePoint.toString(),
        location1TextTitle:
            "$_durationTimeDriverToCaller ($_durationKmDriverToCaller) away",
        location1Text: _endAddressDriverToCaller.length > 36
            ? "${_endAddressDriverToCaller.substring(0, 36)}..."
            : _endAddressDriverToCaller,
        location2TextTitle:
            "$_durationTimeCallerToDestination ($_durationKmCallerToDestination) trip",
        location2Text: _endAddressCallerToDestination.length > 36
            ? "${_endAddressCallerToDestination.substring(0, 36)}..."
            : _endAddressCallerToDestination,
        cancelOnPressed: () async {
          await _driverController.driveCancel(context);
          setState(() {
            _markersSet.clear();
            _polyLineSet.clear();
          });
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.cancelDrive);
        },
        acceptOnPressed: () async {
          var userId = await SessionManager().get('id');
          DriveModel model = DriveModel(driverId: userId);
          await _driverController.driverAccept(context, model);
          _showDriverBottomSheet(0);
        },
      ),
    );
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

  Future<void> sendComment(String comment, int index) async {
    var model = CommentModel(comment: comment, point: index.toDouble());
    model.commentorUserId = driverId;
    var response = await CommentService.instance.comment(model, 'driver');
    // NavigationManager.instance.navigationToPop();
    if (response != null) {}
  }

  Widget _buildDriverBottomSheetContent(int index, BuildContext context) {
    double size = context.height < 620 ? 0.6 : 0.5;

    return SizedBox.expand(
      child: SlideTransition(
        position: _tweens[index].animate(_bottomSheetControllers[index]),
        child: DraggableScrollableSheet(
          initialChildSize: size,
          minChildSize: 0.1,
          maxChildSize: size,
          builder: (BuildContext context, ScrollController scrollController) =>
              SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: DriveBottomSheet(
              height: size,
              buttonTextStart:
                  index == 0 ? 'Start the Trip' : 'Finish the Trip',
              context: context,
              pickingUpText:
                  index == 0 ? 'pickingUpText'.tr() : 'Going to Destination',
              imagePath:
                  "https://randomuser.me/api/portraits/men/93.jpg" /*'$baseUrl/$callerAvaragePoint'*/,
              customerName: '$callerName $callerSurname',
              startText: callerAvaragePoint.toString(),
              location1Text: humanReadableAddress.length > 36
                  ? "${humanReadableAddress.substring(0, 36)}..."
                  : humanReadableAddress,
              location1TextTitle: 'Current Location',
              location2Text: _endAddressCallerToDestination.length > 36
                  ? "${_endAddressCallerToDestination.substring(0, 36)}..."
                  : _endAddressCallerToDestination,
              location2TextTitle:
                  "$_durationTimeCallerToDestination ($_durationKmCallerToDestination) trip",
              showSecondaryButton: index == 0
                  ? true
                  : false, // Eğer index 0 ise showSecondaryButton true olacak
              onPressedStart: () {
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessDialog(
                        context: context,
                        text1:
                            'The funds have been successfully transferred to Toygun X.',
                        title: 'Payment Success',
                        onTap: () {
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
                                selectedIndex:
                                    _controllerComment.starSelectedIndex,
                                context: context,
                                textController: _commentTextController,
                                onPressed: () {
                                  sendComment(_commentTextController.text,
                                      _controllerComment.starSelectedIndex);
                                  setState(() {
                                    HomeScreenTransport.allowNavigation = true;
                                  });

                                  NavigationManager.instance
                                      .navigationToPageClear(
                                          NavigationConstant.homePage);
                                },
                                onPressedRatingBar:
                                    _controllerComment.changeStarSelectedIndex,
                                text:
                                    '${'youRated'.tr()} Fatih${' ${_controllerComment.starSelectedIndex}'} ${'star'.tr()}',
                              );
                            }),
                          );
                        },
                        widget: Column(
                          children: [
                            Text(
                              'Amount',
                              style:
                                  context.textStyle.labelSmallMedium.copyWith(
                                color: HexColor("#5A5A5A"),
                              ),
                            ),
                            Text(
                              totalPaymant.toString(),
                              style:
                                  context.textStyle.titleXlargeRegular.copyWith(
                                color: HexColor("#2A2A2A"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              onPressedCancel: index == 0
                  ? () async {
                      NavigationManager.instance.navigationToPage(
                          NavigationConstant.cancelRide,
                          args: 'driverId');
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  CustomIconButton _buildRightTopButton(BuildContext context) =>
      _driverController.driverActive
          ? _buildCustomIconButton(
              false,
              Icons.close,
              _driverController.driverPassive,
            )
          : _buildCustomIconButton(false, Icons.notifications_none_outlined,
              () {
              NavigationManager.instance
                  .navigationToPage(NavigationConstant.notification);
            });

  Widget _buildTopLeftButton(BuildContext context) {
    return _driverController.driverActive
        ? _buildCustomIconButton(true, Icons.menu, () {
            // TODO: test amaçlı yapılmış olup kaldırılacaktır!
          })
        : SizedBox();
  }

  CustomIconButton _buildCustomIconButton(
          bool isLeft, IconData icon, VoidCallback onPressed) =>
      CustomIconButton(
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
        top: context.responsiveHeight(480) -
            keyboardSize +
            (keyboardSize != 0 ? context.responsiveHeight(150) : 0),
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
            MapsLauncher.launchCoordinates(
                toLatitude, toLongitude, 'Yol Tarifi');
          } else if (driveDetailsInfo.status == 'accept') {
            MapsLauncher.launchCoordinates(
                fromLatitude, fromLongitude, 'Yol Tarifi');
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
          style: context.textStyle.subheadSmallRegular
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppInfo>(context).userDropOffLocation != null &&
        flag == 0) {
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
              if (HomeScreenTransport.allowNavigation)
                _buildTopLeftButton(context),
              if (HomeScreenTransport.allowNavigation)
                _buildRightTopButton(context),
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
