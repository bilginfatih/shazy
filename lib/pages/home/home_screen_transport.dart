import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class HomeScreenTransport extends StatefulWidget {
  HomeScreenTransport({Key? key}) : super(key: key);

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getLocationPermission(); // İzin kontrolü eklendi
    _subscribeToLocationChanges(); // Geolocation Aboneliği eklendi
  }

  // İzinleri kontrol eden fonksiyon
  Future<void> _getLocationPermission() async {
    ph.PermissionStatus status = await Permission.locationWhenInUse.request();
    setState(() {
      _locationPermissionGranted = status.isGranted;
    });
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

  Future<void> _getLocation() async {
    try {
      setState(() {});
    } catch (e) {
      print('Could not get location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location data could not be retrieved.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // onLocationChanged'e abone olunarak konum güncellemeleri alınır
  void _subscribeToLocationChanges() {
    _location.onLocationChanged.listen(
      (LocationData currentLocation) {
        print('Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
        setState(() {});
        _animateToUser(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
      },
    );
  }

  // Kullanıcının konumunu harita üzerinde takip etmek için kamera animasyonu yapar
  Future<void> _animateToUser(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition newPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
