import 'package:mobx/mobx.dart';

import '../../../models/finance/finance_model.dart';
import '../../../services/finance/finance_service.dart';
part 'wallet_controller.g.dart';

class WalletController = _WalletControllerBase with _$WalletController;

abstract class _WalletControllerBase with Store {
  static int incomeLength = 0;
  static int outgoneLength = 0;

  @observable
  List<FinanceModel> financeList = [];

  @observable
  ObservableList<FinanceModel> income = ObservableList.of([]);

  @observable
  List incomeDate = [];

  @observable
  bool isSelectedIncome = true;

  @observable
  ObservableList<FinanceModel> outgone = ObservableList.of([]);

  @observable
  List outgoneDate = [];

  @action
  void select(bool value) {
    isSelectedIncome = value;
  }

  @action
  Future<void> getFinance(String id) async {
    try {
      financeList = await FinanceService.instance.getFinance(id);
      for (var financeItem in financeList) {
        if (financeItem.income != '0.00') {
          income.add(financeItem);
        } else {
          outgone.add(financeItem);
        }
      }
      incomeDate.add(financeList[incomeLength].organizeIncomeDate);
      outgoneDate.add(financeList[outgoneLength].organizeOutgoneDate);
    } catch (e) {
      return;
    }
  }
}
