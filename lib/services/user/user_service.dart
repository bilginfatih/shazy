import 'package:shazy/core/init/network/network_manager.dart';
import 'package:shazy/models/user/user_model.dart';

class UserService {
  UserService();

  static UserService instance = UserService();

  Future<void> register(UserModel user) async {
    try {
      var response = NetworkManager.instance.post('/register', model: user);
    } catch (e) {
      rethrow;
    }
  }
}
