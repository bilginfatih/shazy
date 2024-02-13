import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shazy/utils/helper/helper_functions.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/string_extension.dart';

class AuthController {
  AuthController();

  Future<void> register(BuildContext context, UserModel model) async {
    try {
      if (model.password != model.passwordConfirmation) {
        HelperFunctions.instance.showErrorDialog(
            context, 'passwordNotSame'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
      var response = await UserService.instance.register(model);
      if (response != null) {
        if (context.mounted) {
          HelperFunctions.instance
              .showErrorDialog(context, response, 'cancel'.tr(), () {
            NavigationManager.instance.navigationToPop();
          });
        }
      } else {
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'registerError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  Future<void> login(BuildContext context, UserModel model) async {
    try {
      if (model.email == '' || !model.email!.isValidEmail) {
        HelperFunctions.instance.showErrorDialog(
            context, 'emailValidError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      } else if (model.password == '') {
        HelperFunctions.instance.showErrorDialog(
            context, 'passwordEmptyError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      } else {
        var response = await UserService.instance.login(model);
        if (response != null) {
          if (context.mounted) {
            HelperFunctions.instance
                .showErrorDialog(context, response, 'cancel'.tr(), () {
              NavigationManager.instance.navigationToPop();
            });
          }
        } else {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        }
      }
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'loginError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
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

  Future<void> goToVerifyOTP(
      BuildContext context, UserModel model, bool termsCheck) async {
    if (!termsCheck) {
      HelperFunctions.instance
          .showErrorDialog(context, 'termsError'.tr(), 'cancel'.tr(), () {
        NavigationManager.instance.navigationToPop();
      });
    } else if (model.email == '' || !model.email!.isValidEmail) {
      HelperFunctions.instance
          .showErrorDialog(context, 'emailValidError'.tr(), 'cancel'.tr(), () {
        NavigationManager.instance.navigationToPop();
      });
    } else if (model.name == '' ||
        model.identificationNumber == '' ||
        model.phone == '' ||
        model.gender == '') {
      HelperFunctions.instance.showErrorDialog(
          context, 'registerEmptyError'.tr(), 'cancel'.tr(), () {
        NavigationManager.instance.navigationToPop();
      });
    } else {
      var response = await UserService.instance.registerControl(model);
      if (response != null) {
        if (context.mounted) {
          HelperFunctions.instance
              .showErrorDialog(context, response, 'cancel'.tr(), () {
            NavigationManager.instance.navigationToPop();
          });
        }
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
