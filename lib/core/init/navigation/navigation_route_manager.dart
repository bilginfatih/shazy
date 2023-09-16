import 'package:flutter/material.dart';
import 'package:shazy/pages/contact/message_page.dart';
import 'package:shazy/pages/payment/add_card_page.dart';
import 'package:shazy/pages/payment/payment_method_page.dart';
import '../../../pages/authentication/forget_password_page.dart';
import '../../../pages/authentication/phone_verifiy_otp_page.dart';
import '../../../pages/authentication/send_verification_page.dart';
import '../../../pages/authentication/set_new_password_page.dart';
import '../../../pages/home/search_page.dart';
import '../../../utils/constants/navigation_constant.dart';

import '../../../main.dart';
import '../../../pages/authentication/complete_your_profile_page.dart';
import '../../../pages/authentication/set_password_page.dart';
import '../../../pages/authentication/sign_in_page.dart';
import '../../../pages/authentication/sign_up_page.dart';
import '../../../pages/authentication/verify_otp_page.dart';
import '../../../pages/authentication/welcome_page.dart';
import '../../../pages/home/home_screen_transport.dart';

class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.welcome:
        return _navigationToDefault(const WelcomePage(), args);
      case NavigationConstant.signUp:
        return _navigationToDefault(SignUpPage(), args);
      case NavigationConstant.verifyOtp:
        return _navigationToDefault(VerifyOtpPage(), args);
      case NavigationConstant.setPassword:
        return _navigationToDefault(SetPasswordPage(), args);
      case NavigationConstant.completeProfile:
        return _navigationToDefault(CompleteYourProfilePage(), args);
      case NavigationConstant.signIn:
        return _navigationToDefault(SignInPage(), args);
      case NavigationConstant.sendVerification:
        return _navigationToDefault(SendVerificationPage(), args);
      case NavigationConstant.forgetPassword:
        return _navigationToDefault(const ForgetPasswordPage(), args);
      case NavigationConstant.phoneVerifiyOtpPage:
        return _navigationToDefault(PhoneVerifiyOtpPage(), args);
      case NavigationConstant.setNewPassword:
        return _navigationToDefault(SetNewPassword(), args);
      case NavigationConstant.homeScreenTransport:
        return _navigationToDefault(HomeScreenTransport(), args);
      case NavigationConstant.searchPage:
        return _navigationToDefault(const SearchPage(), args);
      case NavigationConstant.paymentMethod:
        return _navigationToDefault(const PaymetnMethodPage(), args);
      case NavigationConstant.addCard:
        return _navigationToDefault(AddCard(), args);
        case NavigationConstant.message:
        return _navigationToDefault(MessagePage(), args);
      default:
        return _navigationToDefault(MyApp(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) =>
      MaterialPageRoute(builder: (context) => page, settings: args);
}
