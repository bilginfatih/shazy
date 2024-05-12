import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shazy/services/user/user_identity_service.dart';
import '../../core/init/models/caller_home_directions.dart';
import '../../core/init/models/directions.dart';
import '../../core/init/models/driver_home_directions.dart';
import '../../utils/extensions/context_extension.dart';

import '../../core/init/cache/cache_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/theme/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static CallerHomeDirections callerHomeDirections = CallerHomeDirections();
  static Directions directions = Directions();
  static DriverHomeDirections driverHomeDirections = DriverHomeDirections();

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late PermissionStatus status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await cacheManagerCallerDirections();
    await cacheManagerCallerHomeDirections();
    await cacheManagerDriverHomeDirections();
    Platform.isAndroid ? _requestLocationPermission() : null;
    String? email = await CacheManager.instance.getData('user', 'email');
    String? password = await CacheManager.instance.getData('user', 'password');
    if (email == null || password == null) {
      await NavigationManager.instance
          .navigationToPageClear(NavigationConstant.welcome);
    }
    UserModel model = UserModel(email: email, password: password);
    String? data = await UserService.instance.login(model);
    await _setLang();
    if (data != null) {
      await NavigationManager.instance
          .navigationToPageClear(NavigationConstant.welcome);
    } else if (SplashPage.callerHomeDirections.caller_status == 'waitpayment') {
      await UserIdentityService.instance.cacheUserIdentity();
      await NavigationManager.instance
          .navigationToPageClear(NavigationConstant.paymentTip);
    } else {
      await UserIdentityService.instance.cacheUserIdentity();
      await NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
    }
  }

  Future<void> cacheManagerCallerDirections() async {
    var box = await Hive.openBox('directions');
    var response = await box.get('directions');
    if (response != null) {
      SplashPage.directions = SplashPage.directions.fromJson(response);
    } else {
      SplashPage.directions = Directions();
    }
  }

  Future<void> cacheManagerCallerHomeDirections() async {
    var box = await Hive.openBox('caller_directions');
    var response = await box.get('caller_directions');
    if (response != null) {
      SplashPage.callerHomeDirections =
          SplashPage.callerHomeDirections.fromJson(response);
    } else {
      SplashPage.callerHomeDirections = CallerHomeDirections();
    }
  }

  Future<void> cacheManagerDriverHomeDirections() async {
    var box = await Hive.openBox('driver_directions');
    var response = await box.get('driver_directions');
    if (response != null) {
      SplashPage.driverHomeDirections =
          SplashPage.driverHomeDirections.fromJson(response);
    } else {
      SplashPage.driverHomeDirections = DriverHomeDirections();
    }
  }

  Future<void> _setLang() async {
    String? lang = await CacheManager.instance.getData('user', 'lang');
    if (lang != null && lang != 'en' && mounted) {
      await context.setLocale(Locale(lang));
      await SessionManager().set('lang', lang);
    }
  }

  Future<void> _requestLocationPermission() async {
    status = await Permission.location.request();
    if (status.isGranted) {
      // İzin verildiğinde yapılacak işlemler
      print('izin verdisplash');
    } else if (status.isDenied) {
      // İzin reddedildiğinde yapılacak işlemler
      print('reddedildisplash');
      openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // İzin kalıcı olarak reddedildiğinde yapılacak işlemler
      print('İzin kalıcı olarak reddedildisplash');
      openAppSettings();
      //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lokasyon İzinleri'),
          content: Text(
              'Uygulamanın konum izni gerektiği için ayarlara gitmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings(); // Ayarlara gitmek için izinleri ayarlar
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
            Container(
              width: context.responsiveWidth(120),
              height: context.responsiveHeight(120),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: Image.asset(
                "assets/png/logo.jpg",
              ),
            ),
          /*  SizedBox(
              height: context.responsiveHeight(7),
            ),
            Text(
              'Shazy',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: context.responsiveFont(50),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
