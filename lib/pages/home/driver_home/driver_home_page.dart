import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';

import '../../../core/assistants/asistant_methods.dart';
import '../../../core/base/app_info.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/extensions/context_extension.dart';
import '../../../widgets/buttons/icon_button.dart';

import '../../../widgets/dialogs/search_driver_dialog.dart';
import '../../../widgets/drawer/custom_drawer.dart';

class DriverHomePage extends StatefulWidget {
  DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = '';
    if (mounted) {
      humanReadableAddress =
          await AssistantMethods.searchAddressForGeographicCoOrdinates(
              userCurrentPosition!, context);
    }
    print("this is your address = " + humanReadableAddress);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getLocationPermission(); // İzin kontrolü eklendi
    // _subscribeToLocationChanges(); // Geolocation Aboneliği eklendi
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night_theme.json')
        .then(
      (value) {
        mapTheme = value;
      },
    );
  }

  // İzinleri kontrol eden fonksiyon
  Future<void> _getLocationPermission() async {
    ph.PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      print('Lokasyon izni verildi.');
    } else if (status.isDenied) {
      print('Lokasyon izni verilmedi.');
    } else if (status.isPermanentlyDenied) {
      print('Lokasyon izni kalıcı olarak rededildi.');
      _showPermissionSettingsDialog(); // Ayarlara gitme işlemi için fonksiyonu çağır
    }
  }

  // Ayarlara gitme işlemi için bir diyalog gösteren fonksiyon
  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lokasyon İzinleri'),
          content: Text(
              'Uygulamanın konum izni gerektiği için ayarlara gitmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                ph.openAppSettings(); // Ayarlara gitmek için izinleri ayarlar
                Navigator.of(context).pop();
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
    double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              _buildGoogleMap(context),
              CustomIconButton(
                context: context,
                top: 60,
                left: 15,
                height: context.responsiveHeight(34),
                width: context.responsiveWidth(34),
                icon: Icons.menu,
                color: Colors.black,
                size: 18,
                onPressed: () {},
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
              Padding( // sayfanın alt kısmı
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
                      // TODO: işlemler burada yapılacak!
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(
        context: context,
        email: "deneme@gmail.com",
        name: "Test",
      ),
    );
  }

  GoogleMap _buildGoogleMap(BuildContext context) {
    return GoogleMap(
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
      myLocationButtonEnabled: Platform.isIOS ? true : false,
      zoomControlsEnabled: true,
      polylines: polyLineSet,
      markers: markersSet,
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => SearchDriverDialog(
        context: context,
      ),
    );
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
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

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 95));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(
          title: originPosition.locationName,
          snippet: directionDetailsInfo.duration_text),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName,
          snippet: directionDetailsInfo.distance_text),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }
}
