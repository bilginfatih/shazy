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
  List income = [];

  @observable
  List incomeDate = [];

  @observable
  bool isSelectedIncome = true;

  @observable
  List outgone = [];

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
      incomeDate.add(financeList[incomeLength].organize_income_date);
      income.add(financeList[incomeLength].organize_income);
      outgoneDate.add(financeList[incomeLength].organize_outgone_date);
      outgone.add(financeList[incomeLength].organize_outgone);
    } catch (e) {
      return;
    }
  }
}
