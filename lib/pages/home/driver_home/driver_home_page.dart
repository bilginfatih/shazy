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
import 'package:hive_flutter/adapters.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shazy/pages/home/driver_home/driver_controller/driver_controller.dart';
import 'package:shazy/widgets/dialogs/drive_dialog.dart';

import '../../../core/assistants/asistant_methods.dart';
import '../../../core/base/app_info.dart';
import '../../../core/init/cache/cache_manager.dart';
import '../../../core/init/models/driver_home_directions.dart';
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
import '../../authentication/splash_page.dart';
import '../../history/controller/history_upcoming_controller.dart';
import '../home_screen_transport.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);
  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage>
    with TickerProviderStateMixin {
  DriverHomeDirections driverDirections = DriverHomeDirections();
  Future<void> cacheManagerDriverHomeDirections() async {
    var box = await Hive.openBox('driver_directions');
    var response = await box.get('driver_directions');
    if (response != null) {
      driverDirections = driverDirections.fromJson(response);
    } else {
      _timerIsMatched = Timer.periodic(const Duration(seconds: 10), (timer) {
        // Her 5 saniyede bir istek gönder
        sendRequestMatched();
      });
      driverDirections = DriverHomeDirections();
    }
  }

  String _name = '';
  String _email = '';

  int flag = 0;
  bool isComment = true;
  bool isMatched = true;
  List<LatLng> pLineCoOrdinatesList = [];
  List<LatLng> pLineCoOrdinatesList2 = [];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.802516, 29.439794),
    zoom: 14.4746,
  );

  List<AnimationController> _bottomSheetControllers = [];
  late Timer _canceledTimer;
  final TextEditingController _commentTextController = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _controllerComment = HistoryUpcomingController();
  final DriverController _driverController = DriverController();
  //late int _duraitonKmCallertoDestinationValue = 0;
  final Duration _duration = const Duration(milliseconds: 500);
  //late String _durationKmCallerToDestination = '';
  //late String _durationKmDriverToCaller = '';
  //late String _durationTimeCallerToDestination = '';
  //late String _durationTimeDriverToCaller = '';
  //late String _endAddressCallerToDestination = '';
  //late String _endAddressDriverToCaller = '';
  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  final Set<Polyline> _polyLineSet = {};
  //late String _startAddressCallerToDestination;
  //late String _startAddressDriverToCaller;
  late Timer _timerIsMatched;
  late Timer _timerSendRequest;
  late Timer _timerSendIsCommentCache;
  List<Tween<Offset>> _tweens = [];
  //Position? _userCurrentPosition;

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

    if (_timerSendIsCommentCache.isActive) {
      _timerSendIsCommentCache.cancel();
    }

    _disposeBottomSheetControllers();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cacheManagerDriverHomeDirections();
    _getUserData();

    _initializeBottomSheetControllers();

    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night_theme.json')
        .then(
      (value) {
        _mapTheme = value;
      },
    );

    _driverController.active(context);
  }

  Future<void> sendRequestCanceled() async {
    try {
      driverDirections.api_request_url =
          "/drive-request/${driverDirections.drive_id}";

      var requestResponse = await NetworkManager.instance
          .get(driverDirections.api_request_url.toString());

      driverDirections.driver_status = requestResponse["status"];

      if (driverDirections.driver_status == 'canceled') {
        HomeScreenTransport.allowNavigation = true;
        CacheManager.instance.clearAll('driver_directions');
        _canceledTimer.cancel();
        //drawPolyLineFromOriginToDestination();
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {}
  }

  Future<void> sendRequestMatched() async {
    try {
      driverDirections.driver_id = await SessionManager().get('id');
      String apiUrl =
          "/drive-request/driver/${driverDirections.driver_id}/matched";
      var requestId = await NetworkManager.instance.get(apiUrl);

      driverDirections.drive_id = requestId[0]["id"];
      driverDirections.caller_id = requestId[0]["caller_id"];

      UserProfileModel? userProfile = await UserService.instance
          .getAnotherUser(driverDirections.caller_id.toString());
      driverDirections.caller_avarage_point = userProfile!.averagePoint!;
      driverDirections.caller_name = userProfile.userModel!.name!;
      driverDirections.caller_surname = userProfile.userModel!.surname!;
      driverDirections.caller_picture_path = userProfile.profilePicturePath!;

      driverDirections.api_request_url =
          "/drive-request/${driverDirections.drive_id}";
      _timerIsMatched.cancel();
      // 1. cache
      Provider.of<AppInfo>(context, listen: false)
          .driverDropOffLocationCache(driverDirections);
      _timerSendRequest = Timer.periodic(const Duration(seconds: 10), (timer) {
        // Her 5 saniyede bir istek gönder
        sendRequest();
      });
    } catch (e) {
      print('henüz sürüş bulunamadı');
    }
  }

  Future<void> sendRequest() async {
    try {
      var requestResponse = await NetworkManager.instance
          .get(driverDirections.api_request_url.toString());

      if (requestResponse != null) {
        driverDirections.driver_status = requestResponse["status"];
        //String driverId = requestResponse["driver_id"];
        driverDirections.driver_latitude =
            double.parse(requestResponse["driver_lat"]);
        driverDirections.driver_longitude =
            double.parse(requestResponse["driver_lang"]);
        driverDirections.from_latitude =
            double.parse(requestResponse["from_lat"]);
        driverDirections.from_longitude =
            double.parse(requestResponse["from_lang"]);
        driverDirections.to_latitude = double.parse(requestResponse["to_lat"]);
        driverDirections.to_longitude =
            double.parse(requestResponse["to_lang"]);
        //2. cache
        Provider.of<AppInfo>(context, listen: false)
            .driverDropOffLocationCache(driverDirections);

        if (driverDirections.driver_status == 'matched' && isMatched) {
          HomeScreenTransport.allowNavigation = false;
          isMatched = false;
          drawPolyLineFromOriginToDestination();
          _canceledTimer = Timer.periodic(Duration(seconds: 5), (timer) {
            sendRequestCanceled();
          });
        } else if (driverDirections.driver_status == 'comment' && isComment) {
          isComment = false;
          _timerSendRequest.cancel();
          _canceledTimer.cancel();
          //_timerIsMatched.cancel();
          // ignore: use_build_context_synchronously
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                context: context,
                text1:
                    'The funds have been successfully transferred to ${driverDirections.caller_name} ${driverDirections.caller_surname}.',
                title: 'Payment Success',
                onTap: () async {
                  NavigationManager.instance.navigationToPop();
                  _bottomSheetControllers[1].reverse();
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
                    builder: (_) => Observer(builder: (context) {
                      return CommentBottomSheet(
                        selectedIndex: _controllerComment.starSelectedIndex,
                        context: context,
                        textController: _commentTextController,
                        onPressed: () async {
                          CacheManager.instance.clearAll('driver_directions');
                          await sendComment(_commentTextController.text,
                              _controllerComment.starSelectedIndex);
                          setState(() {
                            HomeScreenTransport.allowNavigation = true;
                          });

                          NavigationManager.instance.navigationToPageClear(
                              NavigationConstant.homePage);
                        },
                        onPressedRatingBar:
                            _controllerComment.changeStarSelectedIndex,
                        text:
                            '${'youRated'.tr()} ${driverDirections.caller_name} ${' ${_controllerComment.starSelectedIndex}'} ${'star'.tr()}',
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
                      '${driverDirections.totalPayment.toString()}₺',
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
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //_userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(cPosition.latitude, cPosition.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    _newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      //humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(cPosition, context);
    }
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    //kullanıcı konum alma lazım olursa diye****
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //_userCurrentPosition = cPosition;

    var driverOriginLatLng = LatLng(cPosition.latitude, cPosition.longitude);
    var originLatLng = LatLng(
        driverDirections.from_latitude!, driverDirections.from_longitude!);
    var destinationLatLng =
        LatLng(driverDirections.to_latitude!, driverDirections.to_longitude!);

    var driverDirectionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            driverOriginLatLng, originLatLng);

    driverDirections.distance_text_driver_caller =
        driverDirectionDetailsInfo!.distance_text.toString();
    driverDirections.duration_text_driver_caller =
        driverDirectionDetailsInfo.duration_text.toString();
    driverDirections.start_address_driver_location =
        driverDirectionDetailsInfo.start_address.toString();
    driverDirections.end_address_caller_location =
        driverDirectionDetailsInfo.end_address.toString();
    driverDirections.e_points_driver = driverDirectionDetailsInfo.e_pointsDrive;

    PolylinePoints pPointsDriver = PolylinePoints();
    List<PointLatLng> driverDecodedPolyLinePointsResultList = pPointsDriver
        .decodePolyline(driverDirections.e_points_driver.toString());

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

    driverDirections.distanceKmCallerToDestination =
        directionDetailsInfo!.distance_text.toString();
    driverDirections.durationTimeCallerToDestination =
        directionDetailsInfo.duration_text.toString();
    //_startAddressCallerToDestination = directionDetailsInfo.start_address.toString();
    driverDirections.endAddressCallerToDestination =
        directionDetailsInfo.end_address.toString();
    driverDirections.distanceKmCallertoDestinationValue =
        directionDetailsInfo.distance_value!;

    driverDirections.totalPayment =
        ((driverDirections.distanceKmCallertoDestinationValue! / 1000) * 35)
            .toInt();
    if (driverDirections.totalPayment! < 180) {
      driverDirections.totalPayment = 180;
    }
    driverDirections.e_points = directionDetailsInfo.e_points;

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(driverDirections.e_points.toString());

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
    if (SplashPage.driverHomeDirections.driver_status != 'accept' &&
        SplashPage.driverHomeDirections.driver_status != 'driving') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => DriverDialog(
          context: context,
          price: '${driverDirections.totalPayment}₺',
          star: driverDirections.caller_avarage_point.toString(),
          location1TextTitle: (driverDirections.duration_text_driver_caller !=
                  null)
              ? ("${driverDirections.duration_text_driver_caller} (${driverDirections.distance_text_driver_caller}) away")
              : '',
          location1Text: (driverDirections.end_address_caller_location != null
              ? (driverDirections.end_address_caller_location!.length > 36
                  ? "${driverDirections.end_address_caller_location!.substring(0, 36)}..."
                  : driverDirections.end_address_caller_location!)
              : ''),
          location2TextTitle: (driverDirections
                      .durationTimeCallerToDestination !=
                  null)
              ? ("${driverDirections.durationTimeCallerToDestination} (${driverDirections.distanceKmCallerToDestination}) trip")
              : '',
          location2Text: (driverDirections.endAddressCallerToDestination != null
              ? (driverDirections.endAddressCallerToDestination!.length > 36
                  ? "${driverDirections.endAddressCallerToDestination!.substring(0, 36)}..."
                  : driverDirections.endAddressCallerToDestination!)
              : ''),
          cancelOnPressed: () async {
            CacheManager.instance.clearAll('driver_directions');
            await _driverController.driveCancel(context);
            setState(() {
              CacheManager.instance.clearAll('driver_directions');
              _markersSet.clear();
              _polyLineSet.clear();
              pLineCoOrdinatesList.clear();
              pLineCoOrdinatesList2.clear();
            });
            NavigationManager.instance
                .navigationToPageClear(NavigationConstant.cancelDrive);
          },
          acceptOnPressed: () async {
            if (driverDirections.driver_status == 'canceled') {
              CacheManager.instance.clearAll('driver_directions');
              _markersSet.clear();
              _polyLineSet.clear();
              pLineCoOrdinatesList.clear();
              pLineCoOrdinatesList2.clear();
              NavigationManager.instance
                  .navigationToPageClear(NavigationConstant.homePage);
            } else {
              var userId = await SessionManager().get('id');
              DriveModel model = DriveModel(driverId: userId);
              if (context.mounted) {
                await _driverController.driverAccept(context, model);
              }
              _showDriverBottomSheet(0);
            }
          },
        ),
      );
    }
  }

  Future<void> sendComment(String comment, int index) async {
    var model = CommentModel(comment: comment, point: index.toDouble());
    model.commentorUserId = driverDirections.driver_id;
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
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0)),
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0)),
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
          builder: (BuildContext context, ScrollController scrollController) =>
              SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            child: DriveBottomSheet(
              height: size,
              buttonTextStart:
                  index == 0 ? 'startTheTrip'.tr() : 'finishTheTrip'.tr(),
              context: context,
              pickingUpText:
                  index == 0 ? 'pickingUpText'.tr() : 'goingToDestination',
              imagePath:
                  "https://randomuser.me/api/portraits/men/93.jpg" /*'$baseUrl/$callerAvaragePoint'*/,
              customerName:
                  '${driverDirections.caller_name} ${driverDirections.caller_surname}',
              startText: driverDirections.caller_avarage_point.toString(),
              location1Text: index == 0
                  ? (driverDirections.start_address_driver_location != null
                      ? (driverDirections
                                  .start_address_driver_location!.length >
                              36
                          ? "${driverDirections.start_address_driver_location!.substring(0, 36)}..."
                          : driverDirections.start_address_driver_location!)
                      : '')
                  : (driverDirections.end_address_caller_location != null
                      ? (driverDirections.end_address_caller_location!.length >
                              36
                          ? "${driverDirections.end_address_caller_location!.substring(0, 36)}..."
                          : driverDirections.end_address_caller_location!)
                      : ''),

              location1TextTitle: 'currentLocation'.tr(),
              location2Text: index == 0
                  ? (driverDirections.end_address_caller_location != null
                      ? (driverDirections.end_address_caller_location!.length >
                              36
                          ? "${driverDirections.end_address_caller_location!.substring(0, 36)}..."
                          : driverDirections.end_address_caller_location!)
                      : '')
                  : (driverDirections.endAddressCallerToDestination != null
                      ? (driverDirections
                                  .endAddressCallerToDestination!.length >
                              36
                          ? "${driverDirections.endAddressCallerToDestination!.substring(0, 36)}..."
                          : driverDirections.endAddressCallerToDestination!)
                      : ''),
              location2TextTitle: index == 0
                  ? (driverDirections.duration_text_driver_caller != null
                      ? ("${driverDirections.duration_text_driver_caller} (${driverDirections.distance_text_driver_caller}) trip")
                      : '')
                  : (driverDirections.duration_text_driver_caller != null
                      ? ("${driverDirections.durationTimeCallerToDestination} (${driverDirections.distanceKmCallerToDestination}) trip")
                      : ''),
              showSecondaryButton: index == 0
                  ? true
                  : false, // Eğer index 0 ise showSecondaryButton true olacak
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
                  await PaymentService.instance
                      .waitPayment(driverDirections.driver_id.toString());
                }
              },
              onPressedCancel: index == 0
                  ? () async {
                      _markersSet.clear();
                      _polyLineSet.clear();
                      pLineCoOrdinatesList.clear();
                      pLineCoOrdinatesList2.clear();
                      CacheManager.instance.clearAll('driver_directions');
                      NavigationManager.instance.navigationToPage(
                          NavigationConstant.cancelRide,
                          args: driverDirections.driver_id);
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
          ? _buildCustomIconButton(false, Icons.close, () {
              _driverController.driverPassive(context);
            })
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
          if (driverDirections.driver_status == 'driving') {
            MapsLauncher.launchCoordinates(driverDirections.to_latitude!,
                driverDirections.to_longitude!, 'Yol Tarifi');
          } else if (driverDirections.driver_status == 'accept') {
            MapsLauncher.launchCoordinates(driverDirections.from_latitude!,
                driverDirections.from_longitude!, 'Yol Tarifi');
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
          style: context.textStyle.subheadSmallRegular.copyWith(
              color: Colors.white, fontSize: context.responsiveFont(14)),
        ),
      ),
    );
  }

  int cacheAcceptFlag = 0;
  int cacheDrivingFlag = 0;

  @override
  Widget build(BuildContext context) {
    if (SplashPage.driverHomeDirections.driver_status == 'accept' &&
        cacheAcceptFlag == 0) {
      cacheAcceptFlag = 1;
      _timerSendRequest = Timer.periodic(const Duration(seconds: 10), (timer) {
        // Her 5 saniyede bir istek gönder
        sendRequest();
      });
      _canceledTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        sendRequestCanceled();
      });
      var controller = _bottomSheetControllers[0];
      drawPolyLineFromOriginToDestination();
      HomeScreenTransport.allowNavigation = false;
      controller.forward();
    }
    if (SplashPage.driverHomeDirections.driver_status == 'driving' &&
        cacheDrivingFlag == 0) {
      cacheDrivingFlag == 1;
      var controller = _bottomSheetControllers[1];
      controller.forward();

      _timerSendRequest = Timer.periodic(const Duration(seconds: 10), (timer) {
        // Her 5 saniyede bir istek gönder
        sendRequest();
      });
      _canceledTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        sendRequestCanceled();
      });
      drawPolyLineFromOriginToDestination();
      HomeScreenTransport.allowNavigation = false;
    }
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
        email: _email,
        name: _name,
      ),
    );
  }

  Future<void> _getUserData() async {
    _name = await CacheManager.instance.getData('user', 'name');
    _email = await CacheManager.instance.getData('user', 'email');
    setState(() {});
  }
}
