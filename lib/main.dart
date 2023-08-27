import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'utils/extensions/context_extension.dart';
import 'utils/theme/themes.dart';
import 'core/init/navigation/navigation_manager.dart';
import 'core/init/navigation/navigation_route_manager.dart';
import 'package:flutter/services.dart';

void main() async {
  // Konum izni kontrolü
  WidgetsFlutterBinding.ensureInitialized();
  final locationPermissionStatus = await Permission.locationWhenInUse.request();
  if (locationPermissionStatus.isGranted) {
    runApp(MyApp());
  } else {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // İzin verilmezse uygulamayı kapat
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHAZY',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      navigatorKey: NavigationManager.instance.navigationKey,
      onGenerateRoute: (args) => NavigationRouteManager.instance?.generateRoute(args),
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).welcomeMessage,
          style: context.textStyle.titleXlargeRegular.copyWith(),
        ),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context).localeName),
      ),
    );
  }
}
