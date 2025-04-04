import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shazy/services/drive/drive_service.dart';
import 'package:shazy/services/user/user_service.dart';
import '../../core/init/network/network_manager.dart';
import '../../models/drive/drive_model.dart';
import '../../models/history/history_model.dart';

class HistoryService {
  HistoryService._init();

  static HistoryService instance = HistoryService._init();

  Future<List<HistoryModel>> getDriverHistory() async {
    List<HistoryModel> historyModelList = [];
    try {
      var id = await SessionManager().get('id');
      var historyResponse =
          await NetworkManager.instance.get('/history/driver/$id');
      for (var item in historyResponse) {
        HistoryModel model = HistoryModel();
        model = model.fromJson(item);
        DriveModel driveModel = await DriveService.instance
            .getDriverRequest(model.driveRequestId.toString());
        model.driveModel = driveModel;
        model.userProfile =
            await UserService.instance.getAnotherUser(item['caller_id']);
        historyModelList.add(model);
      }
    } catch (e) {
      rethrow;
    }
    return historyModelList;
  }

  Future<List<HistoryModel>> getPassengerHistory() async {
    List<HistoryModel> historyModelList = [];
    try {
      var id = await SessionManager().get('id');
      var historyResponse =
          await NetworkManager.instance.get('/history/caller/$id');
      for (var item in historyResponse) {
        HistoryModel model = HistoryModel();
        model = model.fromJson(item);
        await DriveService.instance
            .getDriverRequest(model.driveRequestId.toString());
        DriveModel driveModel = await DriveService.instance
            .getDriverRequest(model.driveRequestId.toString());
        model.driveModel = driveModel;
        model.userProfile =
            await UserService.instance.getAnotherUser(item['driver_id']);

        historyModelList.add(model);
      }
    } catch (e) {
      rethrow;
    }
    return historyModelList;
  }
}
