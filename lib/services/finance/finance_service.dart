import '../../core/init/network/network_manager.dart';
import '../../models/finance/finance_model.dart';
import '../../pages/wallet/wallet_page.dart';

class FinanceService {
  FinanceService._init();

  static FinanceService instance = FinanceService._init();
  FinanceModel model = FinanceModel();
  // ignore: prefer_typing_uninitialized_variables
  late var response;

  bool totalFlag = true;
  bool incomeFlag = true;
  bool outgoneFlag = false;

  Future<List<FinanceModel>> getFinance(String id) async {
    try {
      List<FinanceModel> financeList = [];
      int totalIncome = 0;
      int totalExpend = 0;
      WalletPage.incomeLength = 0;
      WalletPage.outgoneLength = 0;
      List income = [];
      List incomeDate = [];
      List outgone = [];
      List outgoneDate = [];

      response = await NetworkManager.instance.get('/finance/$id');
      //print('financelistlength: ' + response);

      for (var item in response) {
        model = model.fromJson(item);
        model.created_at = formatDate(model.created_at.toString());
        totalIncome += int.parse(model.income.toString().split('.')[0]);
        totalExpend += int.parse(model.outgone.toString().split('.')[0]);

        model.total_income = totalIncome;
        model.total_expend = totalExpend;

        if (model.income.toString().split('.')[0] != '0') {
          income.add(model.income!.split('.')[0]);
          incomeDate.add(model.created_at);
          WalletPage.incomeLength++;
        } else if (model.outgone.toString().split('.')[0] != '0') {
          outgone.add(model.outgone!.split('.')[0]);
          outgoneDate.add(model.created_at);
          WalletPage.outgoneLength++;
        }
        model.organize_income = income;
        model.organize_income_date = incomeDate;
        model.organize_outgone = outgone;
        model.organize_outgone_date = outgoneDate;
        //print('incomedate: ' + model.organize_income_date.toString());
        //print('outgonedate: ' + model.organize_outgone_date.toString());
        financeList.add(model);
      }

      return financeList;
    } catch (e) {
      return [];
    }
  }

  void organizeFinancialData() {}

  String formatDate(String dateString) {
    // Gelen tarihi 'T' ve 'Z' karakterlerine göre ayır
    List<String> parts = dateString.split("T");
    // Tarihi ' ' karakterlerine göre ayır ve sadece yılın tamamını al
    List<String> dateParts = parts[0].split("-");
    String year = dateParts[0]; // Yılın tamamını al
    String month = getMonthName(dateParts[1]);
    String day = dateParts[2];

    // Saati ':' karakterine göre ayır
    List<String> timeParts = parts[1].split(":");
    String hour = timeParts[0];
    String minute = timeParts[1];

    return "$day $month $year $hour:$minute";
  }

  String getMonthName(String month) {
    switch (month) {
      case "01":
        return "Ocak";
      case "02":
        return "Şubat";
      case "03":
        return "Mart";
      case "04":
        return "Nisan";
      case "05":
        return "Mayıs";
      case "06":
        return "Haziran";
      case "07":
        return "Temmuz";
      case "08":
        return "Ağustos";
      case "09":
        return "Eylül";
      case "10":
        return "Ekim";
      case "11":
        return "Kasım";
      case "12":
        return "Aralık";
      default:
        return "Bilinmeyen Ay";
    }
  }
}
