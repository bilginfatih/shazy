import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/comment/comment_model.dart';
import 'package:shazy/services/comment/comment_service.dart';
import '../../../models/history/history_model.dart';
import '../../../services/history/history_service.dart';
part 'history_upcoming_controller.g.dart';

class HistoryUpcomingController = _HistoryUpcomingControllerBase
    with _$HistoryUpcomingController;

abstract class _HistoryUpcomingControllerBase with Store {
  @observable
  List<HistoryModel> driverList = [];

  @observable
  bool isDriverSelected = true;

  @observable
  List<HistoryModel> passengerList = [];

  @action
  void userSelect(bool isSelected) {
    isDriverSelected = isSelected;
  }

  @action
  Future<void> init() async {
    passengerList = await HistoryService.instance.getPassengerHistory();
    driverList = await HistoryService.instance.getDriverHistory();
  }

  // TODO: bu fonksiyonu view' a ekle
  Future<void> sendComment(CommentModel model) async {
    model.commentorUserId = await SessionManager().get('id');
    var response = await CommentService.instance.comment(model);
    if (response != null) {
      // TODO: hata mesajı basacak
    }
  }
}
