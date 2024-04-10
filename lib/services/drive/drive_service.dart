import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shazy/core/assistants/asistant_methods.dart';
import 'package:shazy/utils/extensions/string_extension.dart';

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
      var response = await NetworkManager.instance
          .post('/drive-request/Active', model: model);
      if (response.containsKey('errors')) {
        return response['message'];
      } else {
        await CacheManager.instance
            .putData('drive', 'drive_id', response['id']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Sürüş id' sini getirir.
  Future<String?> getDriveId() async =>
      await CacheManager.instance.getData('drive', 'drive_id');

  // Sürüşü iptal eder
  Future<String?> driveCancel(DriveModel model) async {
    try {
      var response =
          await NetworkManager.instance.post('$_request/Cancel', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Sürücüyü pasif eder
  Future<String?> driverPassive(DriveModel model) async {
    try {
      var response =
          await NetworkManager.instance.post('$_request/Passive', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> driveMatched(DriveModel model) async {
    try {
      var response =
          await NetworkManager.instance.post('$_request/Matched', model: model);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> driveConfirmed(DriveModel model) async {
    try {
      var response = await NetworkManager.instance
          .post('$_request/Confirmed', model: model);
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
      var response =
          await NetworkManager.instance.post('$_request/Driving', model: model);
      if (response.containsKey('errors')) {
        return response['message'];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<DriveModel> getDriverRequest(String id) async {
    try {
      var response = await NetworkManager.instance.get('$_request/$id');
      DriveModel model = DriveModel();
      model = model.fromJson(response);
      var fromAddressResponse = await AssistantMethods.getAddressFromGoogleMaps(
          LatLng(model.fromLat ?? 00, model.fromLang ?? 0.0));
      model.fromAddress =
          fromAddressResponse['longAddress']?.truncateString(60);
      model.fromShortAddress = fromAddressResponse['shortAddress'];

      var toAddressResponse = await AssistantMethods.getAddressFromGoogleMaps(
          LatLng(model.toLat ?? 00, model.toLang ?? 0.0));

      model.toAddress = toAddressResponse['longAddress']?.truncateString(60);
      model.toShortAddress = toAddressResponse['shortAddress'];
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
