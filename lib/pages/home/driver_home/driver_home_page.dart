import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import 'package:shazy/pages/home/driver_home/driver_controller/driver_controller.dart';

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
  String _mapTheme = '';
  final Set<Marker> _markersSet = {};
  GoogleMapController? _newGoogleMapController;
  final List<LatLng> _pLineCoOrdinatesList = [];
  final Set<Polyline> _polyLineSet = {};
  Position? _userCurrentPosition;
  final DriverController _driverController = DriverController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _getLocationPermission(); // İzin kontrolü eklendi
    // _subscribeToLocationChanges(); // Geolocation Aboneliği eklendi
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night_theme.json')
        .then(
      (value) {
        _mapTheme = value;
      },
    );
    _driverController.active();
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
    String humanReadableAddress = '';
    if (mounted) {
      humanReadableAddress =
          await AssistantMethods.searchAddressForGeographicCoOrdinates(
              _userCurrentPosition!, context);
    }
    print("this is your address = " + humanReadableAddress);
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
                Padding(
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
                      const Center(
                        // TODO: UI burası değişebilir
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
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

  CustomIconButton _buildRightTopButton(BuildContext context) {
    return _driverController.driverActive
        ? CustomIconButton(
            context: context,
            top: context.responsiveHeight(60),
            right: context.responsiveWidth(15),
            height: context.responsiveHeight(34),
            width: context.responsiveWidth(34),
            icon: Icons.close,
            color: Colors.black,
            size: 18,
            onPressed: () {
              NavigationManager.instance.navigationToPage(
                NavigationConstant.notification,
              );
            },
          )
        : CustomIconButton(
            context: context,
            top: context.responsiveHeight(60),
            right: context.responsiveWidth(15),
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
          );
  }

  Widget _buildTopLeftButton(BuildContext context) {
    return _driverController.driverActive
        ? const SizedBox()
        : CustomIconButton(
            context: context,
            top: context.responsiveHeight(60),
            left: context.responsiveWidth(15),
            height: context.responsiveHeight(34),
            width: context.responsiveWidth(34),
            icon: Icons.menu,
            color: Colors.black,
            size: 18,
            onPressed: () {},
          );
  }
}
