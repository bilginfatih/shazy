import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/core/init/cache/cache_manager.dart';

import '../../core/init/network/network_manager.dart';
import '../../models/user/user_identity_model.dart';

class UserIdentityService {
  UserIdentityService._init();
  // TODO: geliştirelecek
  static UserIdentityService get instance => UserIdentityService._init();

  final String _path = '/user-identity';

  Future<void> putUserIdentity(UserIdentityModel model) async {
    try {
      model.userId ??= await SessionManager().get('id');
      await NetworkManager.instance.put('$_path/${model.userId}', model: model);
      await cacheUserIdentity(userId: model.userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserIdentityModel> getUserIdentity(String userId) async {
    UserIdentityModel model = UserIdentityModel();
    try {
      model = await NetworkManager.instance.get('$_path/$userId', model: model);
    } catch (e) {}
    return model;
  }

  Future<void> cacheUserIdentity({String? userId}) async {
    userId ??= await SessionManager().get('id');
    UserIdentityModel userIdentityModel = await getUserIdentity(userId!);
    await CacheManager.instance.putData('user_identity', 'criminal_record',
        userIdentityModel.criminalRecord.toString());
    await CacheManager.instance.putData('user_identity', 'driving_licance',
        userIdentityModel.drivingLicance.toString());
  }

  Future<bool> userIdentityCheck() async {
    String? criminalRecord =
        await CacheManager.instance.getData('user_identity', 'criminal_record');
    String? drivingLicance =
        await CacheManager.instance.getData('user_identity', 'driving_licance');
    if (criminalRecord == null ||
        criminalRecord == 'null' ||
        drivingLicance == null ||
        drivingLicance == 'null') {
      return false;
    }
    return true;
  }
}
