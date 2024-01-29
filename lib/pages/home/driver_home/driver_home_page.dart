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
import 'package:shazy/pages/home/driver_home/driver_controller/driver_controller.dart';
import 'package:shazy/widgets/dialogs/drive_dialog.dart';

import '../../../core/assistants/asistant_methods.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../core/init/network/network_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/extensions/context_extension.dart';
import '../../../widgets/buttons/icon_button.dart';

import '../../../widgets/dialogs/security_code_dialog.dart';
import '../../../widgets/drawer/custom_drawer.dart';
import '../../../widgets/modal_bottom_sheet/drive_bottom_sheet.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with SingleTickerProviderStateMixin {
  late double driverLatitude;
  late double driverLongitude;
  late double fromLatitude;
  late double fromLongitude;
  List<LatLng> pLineCoOrdinatesList = [];
  List<LatLng> pLineCoOrdinatesList2 = [];
  late double toLatitude;
  late double toLongitude;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late AnimationController _bottomSheetController;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  final DriverController _driverController = DriverController();
  final Duration _duration = const Duration(milliseconds: 500);

  late String _durationKmDriverToCaller;
  late String _durationTimeDriverToCaller;
  late String _startAddressDriverToCaller;
  late String _endAddressDriverToCaller;

  late String _durationKmCallerToDestination;
  late String _durationTimeCallerToDestination;
  late String _startAddressCallerToDestination;
  late String _endAddressCallerToDestination;

  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  final Set<Polyline> _polyLineSet = {};
  late Timer _timer;
  final Tween<Offset> _tween = Tween(begin: const Offset(0, 1), end: Offset(0, 0));

  Position? _userCurrentPosition;

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(vsync: this, duration: _duration);

    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
      (value) {
        _mapTheme = value;
      },
    );
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      // Her 5 saniyede bir istek gönder
      sendRequest();
    });
    _driverController.active();
  }

  Future<void> sendRequest() async {
    try {
      String userId = await SessionManager().get('id');
      String id = "/drive-request/driver/$userId/matched";
      var requestId = await NetworkManager.instance.get(id);

      var statusId = requestId[0]["id"];

      final String requestId2 = statusId;
      String apiUrl = "/drive-request/$requestId2";

      var requestResponse = await NetworkManager.instance.get(apiUrl);

      if (requestResponse != null) {
        String status = requestResponse["status"];
        //String driverId = requestResponse["driver_id"];
        driverLatitude = double.parse(requestResponse["driver_lat"]);
        driverLongitude = double.parse(requestResponse["driver_lang"]);
        fromLatitude = double.parse(requestResponse["from_lat"]);
        fromLongitude = double.parse(requestResponse["from_lang"]);
        toLatitude = double.parse(requestResponse["to_lat"]);
        toLongitude = double.parse(requestResponse["to_lang"]);

        if (status == 'matched') {
          _timer.cancel();
          drawPolyLineFromOriginToDestination();
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

  String humanReadableAddress = '';

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
      infoWindow: InfoWindow(title: 'destinationPosition.locationName', snippet: directionDetailsInfo.distance_text),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      _markersSet.add(originMarker);
      _markersSet.add(destinationMarker);
    });

    // ignore: use_build_context_synchronously
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DriverDialog(
        context: context,
        price: '220₺',
        star: '4.9',
        location1TextTitle: "$_durationTimeDriverToCaller ($_durationKmDriverToCaller) away",
        location1Text: _endAddressDriverToCaller.length > 36 ? "${_endAddressDriverToCaller.substring(0, 36)}..." : _endAddressDriverToCaller,
        location2TextTitle: "$_durationTimeCallerToDestination ($_durationKmCallerToDestination) trip",
        location2Text: _endAddressCallerToDestination.length > 36 ? "${_endAddressCallerToDestination.substring(0, 36)}..." : _endAddressCallerToDestination,
        cancelOnPressed: _driverController.driveCancel,
        acceptOnPressed: () {
          _driverController.driverAccept();
          _showDriverBottomSheet();
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
      zoomControlsEnabled: true,
      polylines: _polyLineSet,
      markers: _markersSet,
    );
  }

  void _showDriverBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SizedBox(),
    );

    if (_bottomSheetController.isDismissed) {
      _bottomSheetController.forward();
    } else if (_bottomSheetController.isCompleted) {
      _bottomSheetController.reverse();
    }
  }

  Widget _buildDriverBottomSheetContent(BuildContext context) {
    return SizedBox.expand(
      // drive bottom sheet
      child: SlideTransition(
        position: _tween.animate(_bottomSheetController),
        child: DraggableScrollableSheet(
          initialChildSize: 0.51,
          minChildSize: 0.1,
          maxChildSize: 0.51,
          builder: (BuildContext context, ScrollController scrollController) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: scrollController,
            child: DriveBottomSheet(
              context: context,
              pickingUpText: 'pickingUpText'.tr(),
              imagePath: 'https://via.placeholder.com/54x59',
              customerName: 'customerName',
              startText: 'startText',
              location1Text: humanReadableAddress.length > 36 ? "${humanReadableAddress.substring(0, 36)}..." : humanReadableAddress,
              location1TextTitle: 'Current Location',
              location2Text: "aa",
              location2TextTitle: " trip",
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    /*if (_bottomSheetController.isDismissed) {
      _bottomSheetController.forward();
    } else if (_bottomSheetController.isCompleted) {
      _bottomSheetController.reverse();
    }*/
  }

  ElevatedButton _buildNavigationButton() => ElevatedButton.icon(
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
      );

  CustomIconButton _buildRightTopButton(BuildContext context) => _driverController.driverActive
      ? _buildCustomIconButton(
          false,
          Icons.close,
          _driverController.driverPassive,
        )
      : _buildCustomIconButton(false, Icons.notifications_none_outlined, () {
          NavigationManager.instance.navigationToPage(NavigationConstant.notification);
        });

  Widget _buildTopLeftButton(BuildContext context) => _driverController.driverActive
      ? _buildCustomIconButton(true, Icons.menu, () {
          // TODO: test amaçlı yapılmış olup kaldırılacaktır!
        })
      : SizedBox();

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

  @override
  Widget build(BuildContext context) {
    double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Observer(builder: (_) {
          return Stack(
            children: [
              _buildGoogleMap(context),
              _buildTopLeftButton(context),
              _buildRightTopButton(context),
              _buildBottomOfBody(context, keyboardSize),
              SizedBox.expand(
                // drive bottom sheet
                child: SlideTransition(
                  position: _tween.animate(_bottomSheetController),
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.51,
                    minChildSize: 0.1,
                    maxChildSize: 0.51,
                    builder: (BuildContext context, ScrollController scrollController) => SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      controller: scrollController,
                      child: DriveBottomSheet(
                        context: context,
                        pickingUpText: 'pickingUpText'.tr(),
                        imagePath: 'https://via.placeholder.com/54x59',
                        customerName: 'customerName',
                        startText: 'startText',
                        location1Text: humanReadableAddress.length > 36 ? "${humanReadableAddress.substring(0, 36)}..." : humanReadableAddress,
                        location1TextTitle: 'Current Location',
                        location2Text: 'location2Text',
                        location2TextTitle: 'location2TextTitle',
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return SecurityCodeDialog(
                                context: context,
                                onDialogClosed: () {
                                  _bottomSheetController.reverse();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
