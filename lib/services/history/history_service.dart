import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/core/init/network/network_manager.dart';
import 'package:shazy/models/history/history_model.dart';

class HistoryService {
  HistoryService._init();

  static HistoryService instance = HistoryService._init();

  Future<List<HistoryModel>> getDriverHistory() async {
    List<HistoryModel> model = [];
    try {
      var id = await SessionManager().get('id');
      var response = await NetworkManager.instance.get('/history/driver/$id');
    } catch (e) {
      rethrow;
    }
    return model;
  }

  Future<List<HistoryModel>> getPassengerHistory() async {
    List<HistoryModel> model = [];
    try {
      var id = await SessionManager().get('id');
      var response = await NetworkManager.instance.get('/history/caller/$id');
    } catch (e) {
      rethrow;
    }
    return model;
  }
}
