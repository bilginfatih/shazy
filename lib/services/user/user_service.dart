import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../core/init/cache/cache_manager.dart';
import '../../core/init/network/network_manager.dart';
import '../../models/user/user_model.dart';

class UserService {
  UserService();

  static UserService instance = UserService();

  Future<String?> register(UserModel user) async {
    try {
      var response =
          await NetworkManager.instance.post('/register', model: user);
      if (response.containsKey('message')) {
        return response['message'];
      } else {
        await CacheManager.instance
            .putData('user', 'email', user.email.toString());
        await CacheManager.instance
            .putData('user', 'phone', user.phone.toString());
        await CacheManager.instance
            .putData('user', 'password', user.password.toString());
        await SessionManager().set('token', response['token']);
        await SessionManager().set('id', response['user']['id']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> login(UserModel user) async {
    try {
      var response = await NetworkManager.instance.post('/login', model: user);
      if (response.containsKey('message')) {
        return response['message'];
      } else {
        await CacheManager.instance
            .putData('user', 'email', user.email.toString());
        await CacheManager.instance
            .putData('user', 'phone', user.phone.toString());
        await CacheManager.instance
            .putData('user', 'password', user.password.toString());
        await SessionManager().set('token', response['token']);
        await SessionManager().set('id', response['user']['id']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> getUser() async {
    try {
      UserModel model = UserModel();
      model = await NetworkManager.instance.get<UserModel>('/user', model: model);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
