import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/drive/drive_model.dart';
import 'package:shazy/services/drive/drive_service.dart';
part 'driver_controller.g.dart';

class DriverController = _DriverControllerBase with _$DriverController;

abstract class _DriverControllerBase with Store {
  @observable
  bool driverActive = false;

  @action
  Future<void> active() async {
    try {
      var userId = await SessionManager().get('id');
      DriveModel model = DriveModel(driverId: userId);
      var response = await DriveService.instance.driverActive(model);
      driverActive = true;
    } catch (e) {
      // TODO: hata sayfasına yönlendir.
    }
  }
}
