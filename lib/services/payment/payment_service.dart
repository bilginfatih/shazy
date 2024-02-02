import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

import '../../models/payment/payment_model.dart';

class PaymentService {
  static PaymentService instance = PaymentService();

  Future<String> addCard(PaymentModel model) async {
    try {
      if (model.cardHolderName == '') {
        return 'cardHolderNameError'.tr();
      } else if (model.cardNumber == null || model.cardNumber?.length != 19) {
        return 'cardNumberError'.tr();
      } else if (model.month == '' ||
          model.year == '' ||
          int.tryParse(model.month.toString())! > 12) {
        return 'expirationDateError'.tr();
      } else if (model.cvv == '') {
        return 'cvvError'.tr();
      } else {
        var box = await Hive.openBox('card');
        await box.put('card', model.toJson());
      }
      return '';
    } catch (e) {
      return 'errorMessage'.tr();
    }
  }

  Future<PaymentModel> getCard() async {
    PaymentModel model = PaymentModel();
    try {
      var box = await Hive.openBox('card');
      var response = await box.get('card');
      return model.fromJson(response);
    } catch (e) {
      return model;
    }
  }
}
