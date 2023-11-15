import 'package:mobx/mobx.dart';
part 'wallet_controller.g.dart';

class WalletController = _WalletControllerBase with _$WalletController;

abstract class _WalletControllerBase with Store {
  @observable
  bool isSelectedIncome = true;

  @action
  void select(bool value) {
    isSelectedIncome = value;
  }
}
