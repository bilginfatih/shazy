import 'package:flutter/material.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';

import '../../../main.dart';
import '../../../pages/authentication/sign_in_page.dart';

class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.signIn:
        return _navigationToDefault(const SignInPage(), args);
      default:
        return _navigationToDefault(MyApp(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) =>
      MaterialPageRoute(builder: (context) => page, settings: args);
}
