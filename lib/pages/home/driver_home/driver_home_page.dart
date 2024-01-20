import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import 'package:shazy/pages/home/driver_home/driver_controller/driver_controller.dart';
import 'package:shazy/widgets/dialogs/drive_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/assistants/asistant_methods.dart';
import '../../../core/base/app_info.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../core/init/network/network_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/extensions/context_extension.dart';
import '../../../widgets/buttons/icon_button.dart';

import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/containers/payment_method_container.dart';
import '../../../widgets/dialogs/search_driver_dialog.dart';
import '../../../widgets/drawer/custom_drawer.dart';
import '../../../widgets/icons/circular_svg_icon.dart';
import '../../../widgets/modal_bottom_sheet/drive_bottom_sheet.dart';

class DriverHomePage extends StatefulWidget {
  DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  late Timer _timer;

  late double driverLatitude;
  late double driverLongitude;
  late double fromLatitude;
  late double fromLongitude;
  late double toLatitude;
  late double toLongitude;

  final DriverController _driverController = DriverController();
  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  List<LatLng> pLineCoOrdinatesList = [];
  List<LatLng> pLineCoOrdinatesList2 = [];
  final Set<Polyline> _polyLineSet = {};
  late String _durationKm;
  Position? _userCurrentPosition;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
      (value) {
        _mapTheme = value;
      },
    );
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      // Her 5 saniyede bir istek gönder
      sendRequest();
    });
    _driverController.active();
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer.cancel();
    super.dispose();
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
          _showDriverDialog();
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

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(_userCurrentPosition!.latitude, _userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    _newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = '';
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

  void _showDriverDialog() {
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
        cancelOnPressed: _driverController.driveCancel,
        acceptOnPressed: () {
          _driverController.driverAccept();
          _showDriverBottomSheet();
        },
      ),
    );
  }

  void _showDriverBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => DriveBottomSheet(
        context: context,
        customerName: "Zübeyir X",
        imagePath: "https://randomuser.me/api/portraits/men/93.jpg",
        location1Text: "Bursa",
        location1TextTitle: "Demirtaş Paşa",
        location2Text: "Yalova",
        location2TextTitle: "Yalova",
        pickingUpText: "Test",
        startText: "4.9",
        onPressed: () async {},
      ),
    );
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
      ? _buildCustomIconButton(false, Icons.close, _driverController.driverPassive)
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

  @override
  Widget build(BuildContext context) {
    double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Observer(builder: (_) {
            return Stack(
              children: [
                _buildGoogleMap(context),
                _buildTopLeftButton(context),
                _buildRightTopButton(context),
                _buildBottomOfBody(context, keyboardSize),
              ],
            );
          }),
        ),
      ),
      drawer: CustomDrawer(
        context: context,
        email: "deneme@gmail.com",
        name: "Test",
      ),
    );
  }

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
}
