import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'core/init/language/language_manager.dart';

import 'core/base/app_info.dart';
import 'core/init/navigation/navigation_manager.dart';
import 'core/init/navigation/navigation_route_manager.dart';
import 'utils/theme/themes.dart';

void main() async {
  await _init();
  // Konum izni kontrolü
  final locationPermissionStatus = await Permission.locationWhenInUse.request();
  if (locationPermissionStatus.isGranted) {
    runApp(EasyLocalization(
      supportedLocales: LanguageManager.instance.supportedLocales,
      path: 'assets/translations',
      child: const MyApp(),
      fallbackLocale: LanguageManager.instance.enLocale,
      saveLocale: true,
    ));
  } else {
    SystemChannels.platform.invokeMethod(
        'SystemNavigator.pop'); // İzin verilmezse uygulamayı kapat
  }
}

_init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SHAZY',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        /*localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],*/
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        navigatorKey: NavigationManager.instance.navigationKey,
        onGenerateRoute: (args) =>
            NavigationRouteManager.instance?.generateRoute(args),
        initialRoute: '/',
      ),
    );
  }
}
