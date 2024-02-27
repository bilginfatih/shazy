import '../../core/init/network/network_manager.dart';
import '../../models/user/user_identity.dart';

class UserIdentityService {
  UserIdentityService._init();
  // TODO: geliştirelecek
  static UserIdentityService get instance => UserIdentityService._init();

  final String _path = '/user-identity';

  Future<void> putUserIdentity(UserIdentityModel model) async {
    try {
      var response = await NetworkManager.instance
          .put('$_path/${model.userId}', model: model);
    } catch (e) {}
  }

  Future<UserIdentityModel> getUserIdentity(String userId) async {
    UserIdentityModel model = UserIdentityModel();
    try {
      model = await NetworkManager.instance.get('$_path/$userId', model: model);
    } catch (e) {}
    return model;
  }
}
