import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/models/drive/drive_model.dart';
import 'package:shazy/services/drive/drive_service.dart';
import 'package:shazy/services/payment/payment_service.dart';

import '../../../../core/init/network/network_manager.dart';
import '../../../../utils/constants/navigation_constant.dart';
import '../../../../utils/helper/helper_functions.dart';
part 'driver_controller.g.dart';

class DriverController = _DriverControllerBase with _$DriverController;

abstract class _DriverControllerBase with Store {
  @observable
  bool driverActive = false;

  @action
  Future<void> active(BuildContext context) async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      await DriveService.instance.driverActive(model);
      driverActive = true;
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'driveActiveError'.tr(), 'backHome'.tr(), () {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        });
      }
    }
  }

  Future<void> driverPassive(BuildContext context) async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driverPassive(model);
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'driverPassiveError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        });
      }
    }
  }

  Future<void> driveCancel(BuildContext context) async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driveCancel(model);
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'driveCancelError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  Future<void> driverAccept(BuildContext context, DriveModel model) async {
    try {
      var response = await NetworkManager.instance
          .post('/drive-request/Accept', model: model);
      NavigationManager.instance.navigationToPop();
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'driverAccept'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  /// Sürüş bilgilerini getirir
  // TODO: bu end point daha eklenmedi eklendiğinde driverdialog ve driverbottomsheetbar bilgileri buradan gelicek.
  @action
  Future<void> driveInformation(BuildContext context) async {
    try {} catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'driverAccept'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  Future<bool> waitPayment(BuildContext context, String driverId) async {
    try {
      var response = await PaymentService.instance.waitPayment(driverId);
      if (response != '') {
        if (context.mounted) {
          HelperFunctions.instance
              .showErrorDialog(context, response, 'cancel'.tr(), () {
            NavigationManager.instance.navigationToPop();
          });
        }
      } else {
        return true;
      }
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'paymentError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
    return false;
  }
}
