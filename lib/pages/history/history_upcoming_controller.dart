import 'package:mobx/mobx.dart';
part 'history_upcoming_controller.g.dart';

class HistoryUpcomingController = _HistoryUpcomingControllerBase
    with _$HistoryUpcomingController;

abstract class _HistoryUpcomingControllerBase with Store {
  @observable
  bool isDriverSelected = true;

  @action
  void userSelect(bool isSelected) {
    isDriverSelected = isSelected;
  }
}
