import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/core/init/network/network_manager.dart';
import 'package:shazy/models/user/user_model.dart';

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
        await SessionManager().set('token', response['token']);
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
        await SessionManager().set('token', response['token']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
