import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/models/user/user_model.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/string_extension.dart';

class AuthController {
  AuthController();

  Future<void> register(UserModel model, bool termsCheck) async {
    try {
      await UserService.instance.register(model);
    } catch (e) {
      // TODO: hata mesajı basacal
    }
  }

  void goToVerifyOTP(UserModel model, bool termsCheck) {
    if (!termsCheck) {
      // TODO: hata mesajı
    } else if (model.email == '' && !model.email!.isValidEmail) {
      // TODO: hata mesajı
    } else if (model.name == '' ||
        model.identificationNumber == '' ||
        model.phone == '' ||
        model.gender == '') {
      // TODO: hata mesaji
    } else {
      NavigationManager.instance
          .navigationToPage(NavigationConstant.verifyOtp, args: model);
    }
  }

  void verifyOTP(UserModel model, String code) {
    if (false) {
      // TODO: burada numara doğrulaması yapılacak.
    } else {
      NavigationManager.instance
          .navigationToPage(NavigationConstant.setPassword, args: model);
    }
  }

  void resendCode() {
    // TODO: resend
  }

  void goToSignInPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.signIn);
  }
}
