import '../../core/init/navigation/navigation_manager.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/string_extension.dart';

class AuthController {
  AuthController();

  Future<void> register(UserModel model) async {
    try {
      if (model.password != model.passwordConfirmation) {
        // TODO: hata mesajı basacak
      }
      var response = await UserService.instance.register(model);
      if (response != null) {
        // TODO: hata mesajı basacak
      } else {
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {
      // TODO: hata mesajı basacak
    }
  }

  Future<void> login(UserModel model) async {
    try {
      if (model.email == '') {
        // TODO: hata mesajı basacak
      } else if (model.password == '') {
        // TODO: hata mesajı basacak
      } else {
        var response = await UserService.instance.login(model);
        if (response != null) {
          // TODO: hata mesajı basacak
        } else {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        }
      }
    } catch (e) {
      // TODO: hata mesajı basacak
    }
  }

  Future<void> verifyPhone(String phone) async {
    NavigationManager.instance
        .navigationToPage(NavigationConstant.phoneVerifiyOtpPage);
  }

  Future<void> forgotPassword() async {
    // TODO:
    NavigationManager.instance.navigationToPageClear(NavigationConstant.signIn);
  }

  Future<void> goToVerifyOTP(UserModel model, bool termsCheck) async {
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
      var response = await UserService.instance.registerControl(model);
      if (response != null) {
        // TODO: hata mesajı
      } else {
        NavigationManager.instance
            .navigationToPage(NavigationConstant.verifyOtp, args: model);
      }
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

  void goToSignUpPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.signUp);
  }

  void goToForgetPasswordPage() {
    NavigationManager.instance
        .navigationToPage(NavigationConstant.forgetPassword);
  }
}
