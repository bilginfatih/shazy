import 'package:flutter/material.dart';

import '../../../main.dart';

class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      default:
        return _navigationToDefault(MyApp(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) => MaterialPageRoute(builder: (context) => page, settings: args);
}
