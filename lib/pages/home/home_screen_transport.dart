import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/assistants/asistant_methods.dart';
import '../../core/base/app_info.dart';
import '../../core/init/models/caller_home_directions.dart';
import '../../core/init/models/directions.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../core/init/network/network_manager.dart';
import '../../models/cancel_reason/cancel_reason_model.dart';
import '../../models/drive/drive_model.dart';
import '../../models/searchDistance/search_distance_model.dart';
import '../../models/user/user_profile_model.dart';
import '../../services/cancel_reason/cancel_reason_service.dart';
import '../../services/drive/drive_service.dart';
import '../../services/searchDistance/search_distance_service.dart';
import '../../services/user/user_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/buttons/icon_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/dialogs/search_driver_dialog.dart';
import '../../widgets/icons/circular_svg_icon.dart';
import '../../widgets/modal_bottom_sheet/caller_bottom_sheer.dart';
import '../authentication/splash_page.dart';

class HomeScreenTransport extends StatefulWidget {
  const HomeScreenTransport({
    Key? key,
    this.scaffoldKey,
  }) : super(key: key);

  static bool isAccept = false;
  static String status = '';
  static int flagCanceled = 0;
  static int flagDriving = 0;
  static int flagWaitPayment = 0;
  static bool allowNavigation = true;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> with TickerProviderStateMixin, WidgetsBindingObserver {
  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  Timer _timerSearchDriver = Timer(const Duration(milliseconds: 1), () {});

  CallerHomeDirections callerHomeDirections = CallerHomeDirections();
  Directions? directions = Directions();

  String mapTheme = '';

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  final Uri toLaunch = Uri(scheme: 'https', host: 'www.google.com', path: '/maps/@/data=!4m2!7m1!2e1');



  _onVerificationCodeChanged(String? newCode) {
    setState(() {
      callerHomeDirections.five_security_code = newCode;
    });
  }

  final SearchDistanceService _searchDistanceService = SearchDistanceService.instance;

  DriveModel driveDetailsInfo = DriveModel();
  bool _isAppInSearchDrive = false;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};

  Position? userCurrentPosition;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
    print('customer_lat: ' + userCurrentPosition!.latitude.toString() + ' customer_long:' + userCurrentPosition!.longitude.toString());
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.802516, 29.439794),
    zoom: 14.4746,
  );

  List<AnimationController> _bottomSheetControllers = [];
  List<Tween<Offset>> _tweens = [];
  final Duration _duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    //_getLocationPermission(); // İzin kontrolü eklendi
    // _subscribeToLocationChanges(); // Geolocation Aboneliği eklendi
    WidgetsBinding.instance.addObserver(this);
    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
      (value) {
        mapTheme = value;
      },
    );
    _initializeBottomSheetControllers();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    if (_timerSearchDriver.isActive) {
      _timerSearchDriver.cancel();
    }

    _disposeBottomSheetControllers();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _disposeBottomSheetControllers() {
    for (var controller in _bottomSheetControllers) {
      controller.dispose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      if (_isAppInSearchDrive == true) {
        if (driveDetailsInfo.status == 'matched') {
          String userId = await SessionManager().get('id');
          CancelReasonModel model = CancelReasonModel(
            callerId: userId,
            status: 'matched',
            reason: 'Caller tarafından driver arama yerinde uygulama kapatıldı',
          );
          await CancelReasonService.instance.cancelReason(model);
          NavigationManager.instance.navigationToPop();
          _timerSearchDriver.cancel();
          print('uygulama kapandı');
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _isAppInSearchDrive = false;
      });
      print('uygulama devam etti');
      // Uygulama tekrar açıldığında yapılacak işlemler burada gerçekleştirilir
    }
  }

  Future<void> isMatched() async {
    var directionsDetails = Provider.of<AppInfo>(context, listen: false).callerDropOffLocation;
    try {
      String userId = await SessionManager().get('id');
      String id = "/drive-request/caller/$userId/${directionsDetails!.caller_status}";
      var requestId = await NetworkManager.instance.get(id);

      callerHomeDirections.drive_id = requestId[0]["id"];
      callerHomeDirections.driver_id = requestId[0]["driver_id"];

      UserProfileModel? userProfile = await UserService.instance.getAnotherUser(callerHomeDirections.driver_id.toString());
      callerHomeDirections.driver_avarage_point = userProfile!.averagePoint!;
      SplashPage.callerHomeDirections.driver_avarage_point = userProfile.averagePoint!;
      callerHomeDirections.driver_name = userProfile.userModel!.name!;
      callerHomeDirections.driver_surname = userProfile.userModel!.surname!;
      callerHomeDirections.driver_picture_path = userProfile.profilePicturePath!;

      if (callerHomeDirections.drive_id != '') {
        // 2. cache
        Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);
        _timerSearchDriver.cancel();
        startSendingRequests();
      }
    } catch (e) {}
  }

  Future<void> sendRequest() async {
    //var directionsDetails = Provider.of<AppInfo>(context, listen: false).callerDropOffLocation;
    try {
      String apiUrl = "/drive-request/${callerHomeDirections.drive_id}";

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      if (requestResponse != null) {
        callerHomeDirections.caller_status = requestResponse["status"];

        print('status: ' + callerHomeDirections.caller_status.toString());

        if (callerHomeDirections.caller_status == 'accept' && callerHomeDirections.isAccept != true) {
          callerHomeDirections.isAccept = true;

          String userId = await SessionManager().get('id');
          String securityCodeUrl = "/security-code/callerCode/$userId";
          var requestSecurityCode = await NetworkManager.instance.get(securityCodeUrl);
          var statusSecurityCode = requestSecurityCode["security-code"]["caller"];

          List<String> callerParts = statusSecurityCode.split(',');
          callerHomeDirections.five_security_code = callerParts.length > 1 ? callerParts[1] : null;
          //SplashPage.callerHomeDirections.five_security_code = callerParts.length > 1 ? callerParts[1] : null;

          _onVerificationCodeChanged(callerHomeDirections.five_security_code);
          // _onVerificationCodeChanged(SplashPage.callerHomeDirections.five_security_code);
          Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);
          NavigationManager.instance.navigationToPop();
          _showCallerBottomSheet(0);

          //_timer.cancel();
          HomeScreenTransport.isAccept = true;
          // ignore: use_build_context_synchronously

          //startSendingRequestsStatus();

          // ignore: use_build_context_synchronously
        } else if (callerHomeDirections.caller_status == 'driving' && HomeScreenTransport.flagDriving == 0) {
          HomeScreenTransport.flagDriving = 1;
          HomeScreenTransport.isAccept = true;
          Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);
          // ignore: use_build_context_synchronously

          _bottomSheetControllers[0].reverse();

          _showCallerBottomSheet(1);
          //_timerStatus.cancel();

          // ignore: use_build_context_synchronously
        } else if (callerHomeDirections.caller_status == 'waitpayment' && HomeScreenTransport.flagWaitPayment == 0) {
          HomeScreenTransport.flagWaitPayment = 1;
          HomeScreenTransport.isAccept = false;
          Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);

          _timer.cancel();
          // ignore: use_build_context_synchronously

          _bottomSheetControllers[1].reverse();
          NavigationManager.instance.navigationToPageClear(NavigationConstant.paymentTip);

          //_timerStatus.cancel();

          // ignore: use_build_context_synchronously
        } else if (callerHomeDirections.caller_status == 'canceled' && HomeScreenTransport.flagCanceled == 0) {
          HomeScreenTransport.flagCanceled = 1;
          HomeScreenTransport.isAccept = false;
          HomeScreenTransport.allowNavigation = true;
          Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);
          // ignore: use_build_context_synchronously

          _showCallerBottomSheet(0);
          //_timerStatus.cancel();
          _timer.cancel();

          // ignore: use_build_context_synchronously
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

  void _showCallerBottomSheet(int index) {
    var directionsDetails = Provider.of<AppInfo>(context, listen: false).callerDropOffLocation;
    if (mounted) {
      var controller = _bottomSheetControllers[index];
      controller.forward();
      setState(
        () {
          if (directionsDetails!.caller_status == 'accept') {
            //HomeScreenTransport.isMatched = true;
          } else {
            _bottomSheetControllers[0].reverse();
            //HomeScreenTransport.isAccept = false;
          }
        },
      );
    }
  }

  Widget _buildCallerBottomSheetContent(int index, BuildContext context) {
    if (SplashPage.directions.totalPayment == null) {
      directions = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    }
    double size = 0.6;
    if (index == 0) {
      size = context.height < 620 ? 0.73 : 0.65;
    } else {
      size = context.height < 620 ? 0.45 : 0.35;
    }
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
            child: CallerBottomSheet(
              height: size,
              shareMyTripButtonText: index == 1 ? 'friendSeeLocation'.tr() : '',
              shareMyTripText: index == 1 ? 'shareMyTrip'.tr() : '',
              showAnathorBuild: index == 0 ? true : false,
              shareButtonTapped: index == 1
                  ? () async {
                      setState(() {
                        _launchInBrowser(toLaunch);
                      });
                    }
                  : () {},
              context: context,
              pickingUpText: index == 0 ? 'Meeting Time 10:10' : 'tripToDestionation',
              customerName: '${callerHomeDirections.driver_name} ${callerHomeDirections.driver_surname}',
              imagePath: "https://randomuser.me/api/portraits/men/93.jpg",
              /*'$baseUrl/$driverPicturePath',*/
              startText: callerHomeDirections.driver_avarage_point.toString(),
              paymentText: 'paymentMethod'.tr(),
              totalPaymentText: "${directions?.totalPayment.toString()}₺",
              verificationCodeText: callerHomeDirections.five_security_code.toString(),
              onPressedCancel: () async {
                NavigationManager.instance.navigationToPage(NavigationConstant.cancelRide);
              },
            ),
          ),
        ),
      ),
    );
  }

  void startSendingRequests() async {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      // Her 5 saniyede bir istek gönder
      await sendRequest();
    });
  }

  void startSendingSearchDriver() async {
    _timerSearchDriver = Timer.periodic(Duration(seconds: 10), (timer) async {
      // Her 5 saniyede bir istek gönder
      await onButtonPressed();
    });
  }

  int flag = 0;

  @override
  Widget build(BuildContext context) {
    if (SplashPage.callerHomeDirections.caller_status != null) {
      callerHomeDirections = SplashPage.callerHomeDirections;
      directions = SplashPage.directions;
      print(directions?.totalPayment.toString());
    }
    if (SplashPage.callerHomeDirections.caller_status == 'accept') {
      callerHomeDirections.isAccept = true;
      startSendingRequests();
      var controller = _bottomSheetControllers[0];
      drawPolyLineFromOriginToDestinationCache();
      HomeScreenTransport.isAccept = true;
      HomeScreenTransport.allowNavigation = false;
      controller.forward();
    }
    if (SplashPage.callerHomeDirections.caller_status == 'driving') {
      startSendingRequests();
      var controller = _bottomSheetControllers[1];
      drawPolyLineFromOriginToDestinationCache();
      HomeScreenTransport.isAccept = true;
      HomeScreenTransport.allowNavigation = false;
      controller.forward();
    }

    if (Provider.of<AppInfo>(context).userDropOffLocation != null && flag == 0) {
      drawPolyLineFromOriginToDestination();
      flag = 1;
    } else {
      print('çizme işlem yapılmadı');
    }
    double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  newGoogleMapController = controller;
                  if (!context.isLight) {
                    setState(() {
                      controller.setMapStyle(mapTheme);
                    });
                  }
                  locateUserPosition();
                },
                myLocationEnabled: true,
                padding: Platform.isIOS ? EdgeInsets.only(bottom: 230) : EdgeInsets.only(top: 100),
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                polylines: polyLineSet,
                markers: markersSet,
              ),
              CustomIconButton(
                context: context,
                top: context.responsiveHeight(60),
                left: context.responsiveWidth(15),
                height: context.responsiveHeight(34),
                width: context.responsiveHeight(34),
                icon: Icons.menu,
                color: Colors.black,
                size: context.responsiveHeight(18),
                onPressed: () {
                  if (HomeScreenTransport.allowNavigation) {
                    widget.scaffoldKey?.currentState?.openDrawer();
                  }
                },
              ),
              CustomIconButton(
                context: context,
                top: context.responsiveHeight(60),
                right: context.responsiveWidth(15),
                height: context.responsiveHeight(34),
                width: context.responsiveHeight(34),
                icon: Icons.notifications_none_outlined,
                color: Colors.black,
                size: context.responsiveHeight(18),
                onPressed: () {
                  NavigationManager.instance.navigationToPage(
                    NavigationConstant.notification,
                  );
                },
              ),
              HomeScreenTransport.isAccept != true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: context.responsiveHeight(480) - keyboardSize + (keyboardSize != 0 ? context.responsiveHeight(150) : 0),
                        right: context.responsiveWidth(15),
                        left: context.responsiveWidth(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: context.responsiveHeight(45),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: context.isLight ? Colors.white : HexColor('#1F212A'),
                                border: Border.all(
                                  color: context.isLight ? Colors.white : AppThemes.lightPrimary500,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              width: context.responsiveWidth(364),
                              height: context.responsiveHeight(141),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 13,
                                  right: 14,
                                  left: 14,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: context.responsiveHeight(54),
                                      width: context.responsiveWidth(336),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: AppThemes.lightPrimary500,
                                            ),
                                          ),
                                          prefixIcon: CircularSvgIcon(
                                            context: context,
                                            assetName: context.isLight ? 'assets/svg/search.svg' : 'assets/svg/search_dark.svg',
                                            decoration: const BoxDecoration(),
                                          ),
                                          hintText: Provider.of<AppInfo>(context).userDropOffLocation != null
                                              ? Provider.of<AppInfo>(context).userDropOffLocation!.endLocationName
                                              : 'whereWouldGo'.tr(),
                                          hintStyle: context.textStyle.subheadLargeMedium.copyWith(
                                            color: AppThemes.hintTextNeutral,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: AppThemes.lightPrimary500,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          NavigationManager.instance.navigationToPage(
                                            NavigationConstant.searchPage,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: context.responsiveHeight(15),
                                    ),
                                    PrimaryButton(
                                      context: context,
                                      text: 'callDriver'.tr(),
                                      height: context.responsiveHeight(48),
                                      width: context.responsiveWidth(334),
                                      buttonStyle: Provider.of<AppInfo>(context).userDropOffLocation != null
                                          ? FilledButton.styleFrom(backgroundColor: AppThemes.lightPrimary500)
                                          : FilledButton.styleFrom(backgroundColor: AppThemes.lightenedColor),
                                      onPressed: Provider.of<AppInfo>(context).userDropOffLocation != null
                                          ? () async {
                                              _isAppInSearchDrive = true;
                                              HomeScreenTransport.flagCanceled = 0;
                                              callerHomeDirections.isAccept = null;
                                              HomeScreenTransport.flagDriving = 0;
                                              HomeScreenTransport.status = '';
                                              HomeScreenTransport.allowNavigation = false;
                                              startSendingSearchDriver();
                                              // ignore: use_build_context_synchronously
                                              showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (BuildContext context) => SearchDriverDialog(
                                                  context: context,
                                                  onPressed: () async {
                                                    if (driveDetailsInfo.status == 'matched') {
                                                      _timerSearchDriver.cancel();
                                                      String userId = await SessionManager().get('id');
                                                      CancelReasonModel model = CancelReasonModel(
                                                        callerId: userId,
                                                        status: 'matched',
                                                        reason: 'Caller tarafından arama yerinde iptal butonuna basıldı',
                                                      );
                                                      await CancelReasonService.instance.cancelReason(model);

                                                      NavigationManager.instance.navigationToPop();
                                                    }
                                                    _timerSearchDriver.cancel();
                                                    NavigationManager.instance.navigationToPop();
                                                  },
                                                ),
                                              );
                                            }
                                          : () {
                                              NavigationManager.instance.navigationToPage(NavigationConstant.searchPage);
                                            },
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                  : SizedBox(),
              _buildCallerBottomSheetContent(0, context),
              _buildCallerBottomSheetContent(1, context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> drawPolyLineFromOriginToDestinationCache() async {
    var originLatLng = LatLng(directions!.currentLocationLatitude!, directions!.currentLocationLongitude!);
    var destinationLatLng = LatLng(directions!.endLocationLatitude!, directions!.endLocationLongitude!);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directions!.e_points.toString());

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    //_durationKm = directions!.distance_text.toString();
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

      polyLineSet.add(polyline);
    });
    /*LatLngBounds boundsLatLng;
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

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95)); */

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: directions!.currentLocationName, snippet: directions!.distance_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: directions!.endLocationName, snippet: directions!.duration_text),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    var originLatLng = LatLng(destinationPosition!.currentLocationLatitude!, destinationPosition.currentLocationLongitude!);
    var destinationLatLng = LatLng(destinationPosition.endLocationLatitude!, destinationPosition.endLocationLongitude!);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(destinationPosition.e_points.toString());

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    //_durationKm = directions!.distance_text.toString();
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

      polyLineSet.add(polyline);
    });
    /*LatLngBounds boundsLatLng;
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

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95)); */

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: destinationPosition.currentLocationName, snippet: destinationPosition.distance_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.endLocationName, snippet: destinationPosition.duration_text),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }

  Future<void> onButtonPressed() async {
    // Kullanıcının konumunu al
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    SearchDistanceModel model = SearchDistanceModel(
      fromLat: cPosition.latitude,
      fromLang: cPosition.longitude,
      toLat: destinationPosition!.endLocationLatitude,
      toLang: destinationPosition.endLocationLongitude,
    );
    // caller sürüş bulduğunda statüsü matched olarak cache
    callerHomeDirections.caller_status = 'matched';
    // 1. cache
    Provider.of<AppInfo>(context, listen: false).callerDropOffLocationCache(callerHomeDirections);

    await _searchDistanceService.searchDistance(model);
    isMatched();
  }
}
