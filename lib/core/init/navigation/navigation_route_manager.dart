import 'package:flutter/material.dart';
import 'package:shazy/pages/menu_side/privacy_policy_page.dart';
import 'package:shazy/pages/profile/profile_edit_page.dart';
import '../../../pages/authentication/splash_page.dart';
import '../../../pages/home/driver_home/driver_home_page.dart';
import '../../../pages/menu_side/about_us.dart';
import '../../../pages/menu_side/change_language_page.dart';
import '../../../pages/menu_side/change_password_page.dart';
import '../../../pages/menu_side/complain.dart';
import '../../../pages/menu_side/contact_us_page.dart';
import '../../../pages/menu_side/delete_account_page.dart';
import '../../../pages/menu_side/driver_choose_page.dart';
import '../../../pages/menu_side/driver_make/driver_accept.dart';
import '../../../pages/menu_side/driver_make/driver_complete.dart';
import '../../../pages/menu_side/driver_make/driver_complete_second.dart';
import '../../../pages/menu_side/driver_make/driver_licance.dart';
import '../../../pages/menu_side/driver_make/driver_unfortunately.dart';
import '../../../pages/menu_side/driver_make/driver_unfortunately_second.dart';
import '../../../pages/menu_side/settings_page.dart';
import '../../../pages/test_2_page.dart';
import '../../../pages/test_pages.dart';
import '../../../pages/contact/cancel_ride_page.dart';
import '../../../pages/contact/message_page.dart';
import '../../../pages/home/home_page.dart';
import '../../../pages/notification/notification_page.dart';
import '../../../pages/offer/offer_page.dart';
import '../../../pages/payment/add_card_page.dart';
import '../../../pages/payment/payment_method_page.dart';
import '../../../pages/payment/payment_tip_page.dart';
import '../../../pages/wallet/wallet_page.dart';
import '../../../pages/authentication/forget_password_page.dart';
import '../../../pages/authentication/phone_verifiy_otp_page.dart';
import '../../../pages/authentication/send_verification_page.dart';
import '../../../pages/authentication/set_new_password_page.dart';
import '../../../pages/history/history_upcoming_page.dart';
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
import '../../../widgets/cancel_drive/cancel_drive.dart';

class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.splash:
        return _navigationToDefault(const SplashPage(), args);
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
      case NavigationConstant.paymentTip:
        return _navigationToDefault( PaymentTipPage(), args);
      case NavigationConstant.cancelRide:
        return _navigationToDefault(CancelRidePage(), args);
      case NavigationConstant.historyUpcoming:
        return _navigationToDefault(HistoryUpcomingPage(), args);
      case NavigationConstant.wallet:
        return _navigationToDefault(WalletPage(), args);
      case NavigationConstant.offer:
        return _navigationToDefault(const OfferPage(), args);
      case NavigationConstant.notification:
        return _navigationToDefault(const NotificationPage(), args);
      case NavigationConstant.homePage:
        return _navigationToDefault(const HomePage(), args);
      case NavigationConstant.driverHomePage:
        return _navigationToDefault(DriverHomePage(), args);
      case NavigationConstant.complain:
        return _navigationToDefault(ComplainPage(), args);
      case NavigationConstant.settings:
        return _navigationToDefault(SettingsPage(), args);
      case NavigationConstant.aboutUs:
        return _navigationToDefault(AboutUsPage(), args);
      case NavigationConstant.changePassword:
        return _navigationToDefault(ChangePasswordPage(), args);
      case NavigationConstant.contactUs:
        return _navigationToDefault(ContactUsPage(), args);
      case NavigationConstant.deleteAccount:
        return _navigationToDefault(DeleteAccountPage(), args);
      case NavigationConstant.driverChoose:
        return _navigationToDefault(DriverChoosePage(), args);
      case NavigationConstant.changeLanguage:
        return _navigationToDefault(ChangeLanguagePage(), args);
      case NavigationConstant.profileEdit:
        return _navigationToDefault(ProfileEditPage(), args);
      case NavigationConstant.driverAccept:
        return _navigationToDefault(DriverAccept(), args);  
      case NavigationConstant.driverLicance:
        return _navigationToDefault(DriverLicance(), args);  
      case NavigationConstant.driverComplete:
        return _navigationToDefault(DriverComplete(), args);  
      case NavigationConstant.driverUnfortunately:
        return _navigationToDefault(DriverUnfortunately(), args);   
      case NavigationConstant.driverUnfortunatelySecond:
        return _navigationToDefault(DriverUnfortunatelySecond(), args); 
      case NavigationConstant.driverCompleteSecond:
        return _navigationToDefault(DriverCompleteSecond(), args);
      case NavigationConstant.cancelDrive:
        return _navigationToDefault(CancelDrive(), args);      
      case NavigationConstant.privacyPolicy:
        return _navigationToDefault(const PrivacyPolicyPage(), args);      
      case NavigationConstant.testPage:
        return _navigationToDefault(TestPage(), args);
      case NavigationConstant.testPage2:
        return _navigationToDefault(Test2Page(), args);
      default:
        return _navigationToDefault(MyApp(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) =>
      MaterialPageRoute(builder: (context) => page, settings: args);
}
