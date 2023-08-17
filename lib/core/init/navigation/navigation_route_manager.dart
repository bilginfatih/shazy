import 'package:flutter/material.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';

import '../../../main.dart';
import '../../../pages/authentication/set_password_page.dart';
import '../../../pages/authentication/sign_in_page.dart';
import '../../../pages/authentication/sign_up_page.dart';

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
        return _navigationToDefault(SignInPage(), args);
      case NavigationConstant.signUp:
        return _navigationToDefault(SignUpPage(), args);
      case NavigationConstant.setPassword:
        return _navigationToDefault(SetPasswordPage(), args);
      default:
        return _navigationToDefault(MyApp(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) => MaterialPageRoute(builder: (context) => page, settings: args);
}
