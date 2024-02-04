import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
import '../../models/drive/drive_model.dart';
import '../../models/searchDistance/search_distance_model.dart';
import '../../services/drive/drive_service.dart';
import '../../services/searchDistance/search_distance_service.dart';
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

class _HomeScreenTransportState extends State<HomeScreenTransport> with TickerProviderStateMixin {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  //final OtpFieldController _pinController = OtpFieldController();
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

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  Timer _timerStatus = Timer(Duration(milliseconds: 1), () {});
  Timer _timerSearchDriver = Timer(Duration(milliseconds: 1), () {});
  Set<Marker> markersSet = {};

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
    if (_timerStatus.isActive) {
      _timerStatus.cancel();
    }
    if (_timerSearchDriver.isActive) {
      _timerSearchDriver.cancel();
    }

    _disposeBottomSheetControllers();
    super.dispose();
  }

  void _disposeBottomSheetControllers() {
    for (var controller in _bottomSheetControllers) {
      controller.dispose();
    }
  }

  Future<void> isMatched() async {
    try {
      String userId = await SessionManager().get('id');
      String id = "/drive-request/caller/$userId/matched";
      var requestId = await NetworkManager.instance.get(id);

      var statusId = requestId[0]["id"];

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
              customerName: 'Zübeyir X',
              imagePath: 'https://via.placeholder.com/54x59',
              startText: 'startText',
              paymentText: 'Payment method',
              totalPaymentText: '220.00₺',
              verificationCodeText: fiveDigitSecurityCode.toString(),
              onPressedCancel: () {},
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
                padding: EdgeInsets.only(bottom: 230),
                myLocationButtonEnabled: true,
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
                  widget.scaffoldKey?.currentState?.openDrawer();
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
                                                context: context,
                                                builder: (BuildContext context) => SearchDriverDialog(
                                                  context: context,
                                                ),
                                              );
                                            }
                                          : () {},
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

  Widget _buildBottomSheet2(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/svg/home-indicator.svg",
            colorFilter: ColorFilter.mode(
              context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
              BlendMode.srcIn,
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationManager.instance.navigationToPop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 325.0),
              child: SvgPicture.asset(
                "assets/svg/cross.svg",
                colorFilter: ColorFilter.mode(
                  context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: context.responsiveHeight(23),
                  width: context.responsiveWidth(167),
                  child: Text(
                    "Trip to Destionation",
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 135.0),
                child: Container(
                  height: context.responsiveHeight(23),
                  width: context.responsiveWidth(70),
                  child: Text(
                    _durationKm,
                    style: context.textStyle.subheadLargeMedium.copyWith(color: context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8')),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: context.responsiveWidth(15)),
          Container(
            height: context.responsiveHeight(1),
            width: context.responsiveWidth(392),
            color: HexColor('#DDDDDD'),
          ),
          SizedBox(height: context.responsiveWidth(19)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  height: context.responsiveHeight(59),
                  width: context.responsiveWidth(54),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey, // Profil resminin rengini belirleyebilirsiniz
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      "https://randomuser.me/api/portraits/men/93.jpg", // Profil resmi dosyasının yolu
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.responsiveWidth(9)),
              Text(
                "Zübeyir X",
                style: context.textStyle.subheadLargeMedium.copyWith(
                  color: HexColor("#2A2A2A"),
                ),
              ),
              SizedBox(width: context.responsiveWidth(107)),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 14,
                  ),
                  Text(
                    "4.9 (531 reviews)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: context.isLight ? HexColor('#A0A0A0') : HexColor('#E8E8E8'),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: context.responsiveWidth(15)),
          Container(
            height: context.responsiveHeight(1),
            width: context.responsiveWidth(392),
            color: HexColor('#DDDDDD'),
          ),
          SizedBox(height: context.responsiveWidth(15)),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: context.responsiveHeight(23),
                  width: context.responsiveWidth(194),
                  child: Text(
                    "Share My Trip",
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: context.responsiveHeight(23),
                  width: context.responsiveWidth(334),
                  child: Text(
                    "Let family and friend see your location and trip status",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: context.isLight ? HexColor('#5A5A5A') : HexColor('#E8E8E8'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  "assets/svg/location.svg",
                ),
                onTap: () {},
              )
            ],
          ),
        ],
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

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    _durationKm = directionDetailsInfo.distance_text.toString();
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

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: directionDetailsInfo.duration_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: directionDetailsInfo.distance_text),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }

  /*Future<void> fitToDriveButtonPressed() async {
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    // Kullanıcının konumunu al
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // DriveModel oluştur ve servisi çağır
    DriveModel model = DriveModel(
      fromLat: cPosition.latitude,
      fromLang: cPosition.longitude,
      toLat: destinationPosition!.locationLatitude!,
      toLang: destinationPosition.locationLongitude!,
    );

    await _driveService.driverActive(model);
  } */

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
