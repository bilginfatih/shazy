import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/core/init/network/network_manager.dart';
import 'package:shazy/models/complain/complain_model.dart';

class ComplainService {
  static ComplainService get instance => ComplainService();

  Future<String?> postComplain(ComplainModel model) async {
    try {
      model.userId = await SessionManager().get('id');
      var response =
          await NetworkManager.instance.post('/complain/store', model: model);
      if (response['message'] != '') {
        return response['message'];
      }
    } catch (e) {
      return 'complainError';
    }
    return null;
  }
}
