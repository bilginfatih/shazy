import 'package:flutter/material.dart';

import 'core/init/navigation/navigation_manager.dart';
import 'core/init/navigation/navigation_route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationManager.instance.navigationKey,
      onGenerateRoute: (args) =>
          NavigationRouteManager.instance?.generateRoute(args),
      initialRoute: '/',
    );
  }
}
