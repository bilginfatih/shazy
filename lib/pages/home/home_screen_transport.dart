import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import '../../core/assistants/asistant_methods.dart';
import '../../core/base/app_info.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/buttons/icon_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/dialogs/search_driver_dialog.dart';
import '../../widgets/icons/circular_svg_icon.dart';

class HomeScreenTransport extends StatefulWidget {
  HomeScreenTransport({Key? key}) : super(key: key);

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

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
    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
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
          content: Text('Uygulamanın konum izni gerektiği için ayarlara gitmek istiyor musunuz?'),
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

  // onLocationChanged'e abone olunarak konum güncellemeleri alınır
  /*void _subscribeToLocationChanges() {
    _location.onLocationChanged.listen(
      (LocationData currentLocation) {
        print('Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
        setState(() {});
        _animateToUser(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
      },
    );
  }*/

  // Kullanıcının konumunu harita üzerinde takip etmek için kamera animasyonu yapar

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
                myLocationButtonEnabled: Platform.isIOS ? true : false,
                zoomControlsEnabled: true,
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
                  debugPrint("object");
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: context.responsiveHeight(480) - keyboardSize + (keyboardSize != 0 ? context.responsiveHeight(150) : 0),
                  right: context.responsiveWidth(15),
                  left: context.responsiveWidth(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: context.responsiveHeight(34),
                      width: context.responsiveWidth(34),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: context.isLight ? Colors.white : Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Kabartma rengi ve opaklık
                            spreadRadius: 2, // Ne kadar genişlemesi gerektiği
                            blurRadius: 4, // Görüntü bulanıklığı
                            offset: const Offset(0, 2), // X ve Y eksenindeki ofset değeri
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.my_location_outlined,
                          color: context.isLight ? HexColor('#61BAAD') : AppThemes.lightPrimary500,
                          size: 19,
                        ),
                        padding: const EdgeInsets.all(5),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: context.responsiveHeight(25),
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
                              onPressed: () async {
                                await drawPolyLineFromOriginToDestination();
                                // ignore: use_build_context_synchronously
                                showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: context.responsiveHeight(479),
                                      child: _buildBottomSheet(context),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Yan Menü',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Seçenek 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Seçenek 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                // Seçenek 1 seçildiğinde yapılacak işlemler
                Navigator.pop(context); // Bottom Sheet'i kapat
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                // Seçenek 2 seçildiğinde yapılacak işlemler
                Navigator.pop(context); // Bottom Sheet'i kapat
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => SearchDriverDialog(
        context: context,
      ),
    );
    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
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
    print(destinationLatLng);
    print(destinationMarker);
    print(destinationPosition);
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
  }
}
