import 'package:mobx/mobx.dart';

import '../../../models/finance/finance_model.dart';
import '../../../services/finance/finance_service.dart';
part 'wallet_controller.g.dart';

class WalletController = _WalletControllerBase with _$WalletController;

abstract class _WalletControllerBase with Store {
  @observable
  List<FinanceModel> financeList = [];

  @observable
  bool isSelectedIncome = true;

  @action
  void select(bool value) {
    isSelectedIncome = value;
  }

  @action
  Future<void> getFinance(String id) async {
    try {
      financeList = await FinanceService.instance.getFinance(id);
    } catch (e) {
      return;
    }
  }
}
