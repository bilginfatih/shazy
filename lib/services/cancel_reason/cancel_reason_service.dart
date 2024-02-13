import '../../core/init/network/network_manager.dart';
import '../../models/cancel_reason/cancel_reason_model.dart';

class CancelReasonService {
  CancelReasonService._init();

  static CancelReasonService instance = CancelReasonService._init();

  Future<void> cancelReason(CancelReasonModel model) async {
    try {
      //String userId = await SessionManager().get('id');
      // ignore: unused_local_variable
      var response = await NetworkManager.instance.post('/drive-request/Cancel', model: model);

    } catch (e) {}
  }
}