import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hive/hive.dart';
import 'package:shazy/core/init/network/network_manager.dart';

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



  Future<String> pay(PaymentModel model) async {
    try {
      String id = await SessionManager().get('id');
      model.uid = id;
      var response =
          await NetworkManager.instance.post('/payment', model: model);
      if (response == '') {
        return '';
      }
      return response['message'];
    } catch (e) {
      print(e);
      return 'paymentError'.tr();
    }
  }

  Future<String> waitPayment(String driverId) async {
    try {
      var request = {'driver_id': driverId};
      var response = await NetworkManager.instance
          .post('/drive-request/WaitPayment', data: request);
      if (response == 0) {
        return '';
      }
      return response['message'];
    } catch (e) {
      return 'waitpayment';
    }
  }
}
