import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shazy/utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/buttons/icon_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/icons/circular_svg_icon.dart';

class HomeScreenTransport extends StatefulWidget {
  HomeScreenTransport({Key? key}) : super(key: key);

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> {
  String mapTheme = '';
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();
  LocationData? _currentLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getLocationPermission(); // İzin kontrolü eklendi
    _subscribeToLocationChanges(); // Geolocation Aboneliği eklendi
    DefaultAssetBundle.of(context).loadString('assets/maptheme/night_theme.json').then(
      (value) {
        mapTheme = value;
      },
    );
  }

  Future<void> _getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
      // ignore: empty_catches
    } catch (e) {}
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
                  if (!context.isLight) {
                    setState(() {
                      controller.setMapStyle(mapTheme);
                    });
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
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
                padding: const EdgeInsets.only(
                  top: 480,
                  right: 15,
                  left: 14,
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
                        onPressed: () {
                          _getLocation();
                          print(_currentLocation!.latitude!.toDouble());
                          _animateToUser(_currentLocation!.latitude!.toDouble(), _currentLocation!.longitude!.toDouble());
                        },
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
                                  hintText: 'Where would you go?',
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
                              onPressed: () {},
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
        items: <BottomNavigationBarItem>[
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
}
