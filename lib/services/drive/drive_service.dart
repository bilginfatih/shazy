import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../core/init/cache/cache_manager.dart';
import '../../models/drive/drive_model.dart';

import '../../core/init/network/network_manager.dart';

class DriveService {
  DriveService();
  DriveService._init();

  static DriveService instance = DriveService._init();

  final String _request = '/drive-request';

  Future<void> driveStatus(DriveModel model) async {
    try {
      String userId = await SessionManager().get('id');
      NetworkManager.instance.get('$_request/driver/$userId/${model.status}');
    } catch (e) {
      rethrow;
    }
  }

  /// Sürücüyü aktif eder.
  /// model paremetreleri: driver_id
  Future<String?> driverActive(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('/drive-request/Active', model: model);
      if (response.containsKey('errors')) {
        return response['message'];
      } else {
        await CacheManager.instance.putData('drive', 'drive_id', response['id']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Sürüş id' sini getirir.
  Future<String?> getDriveId() async => await CacheManager.instance.getData('drive', 'drive_id');

  // Sürüşü iptal eder
  Future<String?> driveCancel(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('$_request/Cancel', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Sürücüyü pasif eder
  Future<String?> driverPassive(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('$_request/Passive', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> driveMatched(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('$_request/Matched', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> driveConfirmed(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('$_request/Confirmed', model: model);
      if (response.containsKey('errors')) {
        return response['message'];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> driving(DriveModel model) async {
    try {
      var response = await NetworkManager.instance.post('$_request/Driving', model: model);
      if (response.containsKey('errors')) {
        return response['message'];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
