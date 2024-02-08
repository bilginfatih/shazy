import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import '../../core/init/cache/cache_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
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

  Future<String?> registerControl(UserModel user) async {
    try {
      bool control = await NetworkManager.instance
          .post('/user/email', data: {'email': user.email});
      print('------');
      print(control);
      print('------');
      if (control) {
        return 'registerEmailError'.tr();
      }
      if (user.phone != null) {
        control = await NetworkManager.instance
            .post('/user/phone', data: {'phone': user.phone});
        if (control) {
          return 'registerPhoneError'.tr();
        }
      }
    } catch (e) {
      return 'registerError'.tr();
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
      model =
          await NetworkManager.instance.get<UserModel>('/user', model: model);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfileModel?> getAnotherUser(String id) async {
    try {
      UserProfileModel model = UserProfileModel();
      var response = await NetworkManager.instance.get('/user-profile/$id');
      model = model.fromJson(response);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    var token = await SessionManager().get('token');
    var request = {'token': token};
    await NetworkManager.instance.post('/logout', data: request);
    _cleanCache();
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    try {
      var userId = await SessionManager().get('id');
      var data = {
        'user_id': userId,
        'old_password': oldPassword,
        'new_password': newPassword,
      };
      var response = await NetworkManager.instance
          .post('/user/password-reset', data: data);
    } catch (e) {
      return 'changePasswordError'.tr();
    }
    return null;
  }

  Future<String?> deleteAccount() async {
    try {
      var id = await SessionManager().get('id');
      var data = {'user_id': id};
      var response = await NetworkManager.instance.delete('/user', data: data);

      if (response['message'] != null) {
        return response['message'];
      } else {
        _cleanCache();
      }
    } catch (e) {
      return 'deleteAccountError'.tr();
    }
    return null;
  }

  Future<void> _cleanCache() async {
    CacheManager.instance.clearAll('user');
    await SessionManager().destroy();
    NavigationManager.instance
        .navigationToPageClear(NavigationConstant.welcome);
  }
}
