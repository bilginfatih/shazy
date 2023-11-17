import 'package:mobx/mobx.dart';
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
}
