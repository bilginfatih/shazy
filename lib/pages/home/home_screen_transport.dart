import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/assistants/asistant_methods.dart';
import '../../core/base/app_info.dart';
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

class HomeScreenTransport extends StatefulWidget {
  HomeScreenTransport({
    Key? key,
    this.scaffoldKey,
  }) : super(key: key);

  static bool isAccept = false;
  static String status = '';
  //static int flagMatched = 0;
  static int flagCanceled = 0;
  static int flagAccept = 0;
  static int flagDriving = 0;
  static bool allowNavigation = true;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> with TickerProviderStateMixin, WidgetsBindingObserver {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  //final OtpFieldController _pinController = OtpFieldController();
  // ignore: unused_field
  late String _durationKm;

  final Uri toLaunch = Uri(scheme: 'https', host: 'www.google.com', path: '/maps/@/data=!4m2!7m1!2e1');

  String? fiveDigitSecurityCode;

  _onVerificationCodeChanged(String? newCode) {
    setState(() {
      fiveDigitSecurityCode = newCode;
    });
  }

  final SearchDistanceService _searchDistanceService = SearchDistanceService.instance;
  final DriveService _driveService = DriveService();

  DriveModel driveDetailsInfo = DriveModel();
  bool _isAppInSearchDrive = false;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  Timer _timerSearchDriver = Timer(Duration(milliseconds: 1), () {});
  Set<Marker> markersSet = {};

  late double driverAvaragePoint = 0.0;
  late String driverName = '';
  late String driverSurname = '';
  late String driverPicturePath = '';

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<AnimationController> _bottomSheetControllers = [];
  List<Tween<Offset>> _tweens = [];
  final Duration _duration = const Duration(milliseconds: 500);

  late String requestId2 = '';

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
    try {
      String userId = await SessionManager().get('id');
      String id = "/drive-request/caller/$userId/matched";
      var requestId = await NetworkManager.instance.get(id);

      var statusId = requestId[0]["id"];

      String driverId = requestId[0]["driver_id"];

      UserProfileModel? userProfile = await UserService.instance.getAnotherUser(driverId);
      driverAvaragePoint = userProfile!.avaragePoint!;
      driverName = userProfile.userModel!.name!;
      driverSurname = userProfile.userModel!.surname!;
      driverPicturePath = userProfile.profilePicturePath!;

      requestId2 = statusId;
      if (requestId2 != '') {
        _timerSearchDriver.cancel();
        startSendingRequests();
      }
      print('requestId2: ' + requestId2);
    } catch (e) {}
  }

  Future<void> sendRequest() async {
    try {
      String apiUrl = "/drive-request/$requestId2";
      print('url: ' + apiUrl);

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      if (requestResponse != null) {
        HomeScreenTransport.status = requestResponse["status"];

        print('status: ' + HomeScreenTransport.status);

        if (HomeScreenTransport.status == 'accept' && HomeScreenTransport.flagAccept == 0) {
          HomeScreenTransport.flagAccept = 1;

          String userId = await SessionManager().get('id');
          String securityCodeUrl = "/security-code/callerCode/$userId";
          var requestSecurityCode = await NetworkManager.instance.get(securityCodeUrl);
          var statusSecurityCode = requestSecurityCode["security-code"]["caller"];

          List<String> callerParts = statusSecurityCode.split(',');
          String? secondPart = callerParts.length > 1 ? callerParts[1] : null;
          fiveDigitSecurityCode = secondPart;

          _onVerificationCodeChanged(secondPart);
          _showCallerBottomSheet(0);

          //_timer.cancel();
          HomeScreenTransport.isAccept = true;
          // ignore: use_build_context_synchronously
          NavigationManager.instance.navigationToPop();
          //startSendingRequestsStatus();

          // ignore: use_build_context_synchronously
        } else if (HomeScreenTransport.status == 'driving' && HomeScreenTransport.flagDriving == 0) {
          HomeScreenTransport.flagDriving = 1;
          HomeScreenTransport.isAccept = true;
          // ignore: use_build_context_synchronously

          _bottomSheetControllers[0].reverse();

          _showCallerBottomSheet(1);
          //_timerStatus.cancel();

          // ignore: use_build_context_synchronously
        } else if (HomeScreenTransport.status == 'canceled' && HomeScreenTransport.flagCanceled == 0) {
          HomeScreenTransport.flagCanceled = 1;
          HomeScreenTransport.isAccept = false;
          HomeScreenTransport.allowNavigation = true;
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
    if (mounted) {
      var controller = _bottomSheetControllers[index];
      controller.forward();
      setState(
        () {
          if (HomeScreenTransport.status == 'accept') {
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
    return SizedBox.expand(
      child: SlideTransition(
        position: _tweens[index].animate(_bottomSheetControllers[index]),
        child: DraggableScrollableSheet(
          initialChildSize: index == 0 ? 0.65 : 0.39,
          minChildSize: 0.1,
          maxChildSize: index == 0 ? 0.65 : 0.39,
          builder: (BuildContext context, ScrollController scrollController) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: scrollController,
            child: CallerBottomSheet(
              height: index == 0 ? 0.58 : 0.35,
              shareMyTripButtonText: index == 1 ? 'Let family and friend see your location and trip status' : '',
              shareMyTripText: index == 1 ? 'Share My Trip' : '',
              showAnathorBuild: index == 0 ? true : false,
              shareButtonTapped: index == 1
                  ? () {
                      setState(() {
                        _launchInBrowser(toLaunch);
                      });
                    }
                  : () {
                      ;
                    },
              context: context,
              pickingUpText: index == 0 ? 'Meeting Time 10:10' : 'Trip to Destionation',
              customerName: '$driverName $driverSurname',
              imagePath: "https://randomuser.me/api/portraits/men/93.jpg",
              /*'$baseUrl/$driverPicturePath',*/
              startText: driverAvaragePoint.toString(),
              paymentText: 'Payment method',
              totalPaymentText: Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null
                  ? "${Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.totalPayment.toString()}₺"
                  : 'null',
              verificationCodeText: fiveDigitSecurityCode.toString(),
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

  // İzinleri kontrol eden fonksiyon
  Future<void> _getLocationPermission() async {
    ph.PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      print('Lokasyon izni verildi.');
    } else if (status.isDenied) {
      print('Lokasyon izni verilmedi.');
    } else if (status.isPermanentlyDenied) {
      print('Lokasyon izni kalıcı olarak rededildi.');
      //_showPermissionSettingsDialog(); // Ayarlara gitme işlemi için fonksiyonu çağır
    }
  }

  // Ayarlara gitme işlemi için bir diyalog gösteren fonksiyon
  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lokasyon İzinleri'),
          content: Text('Uygulamanın konum izni gerektiği için ayarlara gitmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                ph.openAppSettings(); // Ayarlara gitmek için izinleri ayarlar
                NavigationManager.instance.navigationToPop();
              },
              child: const Text('Ayarlara Git'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (HomeScreenTransport.status == 'accept') {
      var controller = _bottomSheetControllers[0];
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
                //padding: EdgeInsets.only(bottom: 230),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                polylines: polyLineSet,
                markers: markersSet,
              ),
              CustomIconButton(
                context: context,
                top: 60,
                left: 15,
                height: context.responsiveHeight(34),
                width: context.responsiveWidth(34),
                icon: Icons.menu,
                color: Colors.black,
                size: 18,
                onPressed: () {
                  if (HomeScreenTransport.allowNavigation) {
                    widget.scaffoldKey?.currentState?.openDrawer();
                  }
                },
              ),
              CustomIconButton(
                context: context,
                top: 60,
                right: 15,
                height: context.responsiveHeight(34),
                width: context.responsiveWidth(34),
                icon: Icons.notifications_none_outlined,
                color: Colors.black,
                size: 18,
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
                                              ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName
                                              : 'Where would you go?',
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
                                      text: 'Call Driver',
                                      height: context.responsiveHeight(48),
                                      width: context.responsiveWidth(334),
                                      buttonStyle: Provider.of<AppInfo>(context).userDropOffLocation != null
                                          ? FilledButton.styleFrom(backgroundColor: AppThemes.lightPrimary500)
                                          : FilledButton.styleFrom(backgroundColor: AppThemes.lightenedColor),
                                      onPressed: Provider.of<AppInfo>(context).userDropOffLocation != null
                                          ? () async {
                                              _isAppInSearchDrive = true;
                                              //HomeScreenTransport.flagMatched = 0;
                                              HomeScreenTransport.flagCanceled = 0;
                                              HomeScreenTransport.flagAccept = 0;
                                              HomeScreenTransport.flagDriving = 0;
                                              HomeScreenTransport.status = '';
                                              requestId2 = '';
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

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(destinationPosition.e_points.toString());

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    _durationKm = destinationPosition.distance_text.toString();
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
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: destinationPosition.distance_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: destinationPosition.duration_text),
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
      toLat: destinationPosition!.locationLatitude,
      toLang: destinationPosition.locationLongitude,
    );

    await _searchDistanceService.searchDistance(model);
    isMatched();
  }
}
