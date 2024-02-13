import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../models/comment/comment_model.dart';
import '../../../services/comment/comment_service.dart';
import '../../../models/history/history_model.dart';
import '../../../services/history/history_service.dart';
part 'history_upcoming_controller.g.dart';

class HistoryUpcomingController = _HistoryUpcomingControllerBase with _$HistoryUpcomingController;

abstract class _HistoryUpcomingControllerBase with Store {
  @observable
  List<HistoryModel> driverList = [];

  @observable
  bool isDriverSelected = true;

  @observable
  ObservableList<HistoryModel> passengerList = ObservableList<HistoryModel>();

  @observable
  int starSelectedIndex = 0;

  @action
  void userSelect(bool isSelected) {
    isDriverSelected = isSelected;
  }

  @action
  Future<void> init() async {
    passengerList.addAll(await HistoryService.instance.getPassengerHistory());
    driverList = await HistoryService.instance.getDriverHistory();
  }

  @action
  void changeStarSelectedIndex(int index) {
    starSelectedIndex = index;
  }

  Future<void> sendComment(String comment, int index) async {
    var model = CommentModel(comment: comment, point: starSelectedIndex.toDouble());
    model.commentorUserId = await SessionManager().get('id');
    var response = await CommentService.instance.comment(model, 'caller');
    init();
    NavigationManager.instance.navigationToPop();
    if (response != null) {
      // TODO: hata mesajı basacak
    }
  }
}
