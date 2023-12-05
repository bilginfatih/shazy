import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/models/drive/drive_model.dart';
import 'package:shazy/services/drive/drive_service.dart';

import '../../../../utils/constants/navigation_constant.dart';
part 'driver_controller.g.dart';

class DriverController = _DriverControllerBase with _$DriverController;

abstract class _DriverControllerBase with Store {
  @observable
  bool driverActive = false;

  @action
  Future<void> active() async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driverActive(model);
      driverActive = true;
    } catch (e) {
      // TODO: hata sayfasına yönlendir.
    }
  }

  Future<void> driverPassive() async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driverPassive(model);
      // TODO: responsa bağlı olarak home page e gidicek
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.homePage);
    } catch (e) {
      // TODO: hata sayfasına yönlendir.
    }
  }

  Future<void> driveCancel() async {
    try {
      var userId = await SessionManager().get('id');
      var model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driveCancel(model);
      if (response != '') {
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.homePage);
      }
    } catch (e) {
      // TODO: hata mesajı gözükecek
    }
  }

  Future<void> driverAccept() async {
    NavigationManager.instance.navigationToPop();
  }

  /// Sürüş bilgilerini getirir
  // TODO: bu end point daha eklenmedi eklendiğinde driverdialog ve driverbottomsheetbar bilgileri buradan gelicek.
  @action
  Future<void> driveInformation() async {
    try {} catch (e) {
      // TODO: hata mesajı gözükecek
    }
  }
}
