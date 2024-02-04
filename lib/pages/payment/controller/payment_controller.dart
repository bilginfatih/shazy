import 'package:mobx/mobx.dart';
import 'package:shazy/core/init/cache/cache_manager.dart';
import 'package:shazy/models/payment/payment_model.dart';
import 'package:shazy/services/payment/payment_service.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
part 'payment_controller.g.dart';

class PaymentController = _PaymentControllerBase with _$PaymentController;

abstract class _PaymentControllerBase with Store {
  @observable
  PaymentModel card = PaymentModel();

  @action
  Future<void> init() async {
    card = await PaymentService.instance.getCard();
  }

  Future<void> addCard(PaymentModel model) async {
    var response = await PaymentService.instance.addCard(model);
    if (response == '') {
      // NavigationManager.instance.navigationToPageClear(NavigationConstant.paymentMethod);
    } else {
      // TODO: hata pop up
    }
  }

  void goToAddCardPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.addCard);
  }
}
