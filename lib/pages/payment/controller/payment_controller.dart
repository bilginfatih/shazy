import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/payment/payment_model.dart';
import 'package:shazy/services/payment/payment_service.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../widgets/dialogs/congratulation_dialog.dart';
part 'payment_controller.g.dart';

class PaymentController = _PaymentControllerBase with _$PaymentController;

abstract class _PaymentControllerBase with Store {
  @observable
  PaymentModel card = PaymentModel();

  @action
  Future<void> init() async {
    card = await PaymentService.instance.getCard();
  }

  Future<void> pay(double amount, BuildContext context,
      {String driverName = ''}) async {
    try {
      // TODO: gelen response göre düzenlenecek
      var response = await PaymentService.instance.pay(card);
      if (context.mounted) {
        if (response == '') {
          showDialog(
            context: context,
            builder: (_) => SuccessDialog(
              context: context,
              title: 'paymentSuccess'.tr(),
              text1: '${'yourMoneyHasBeenSuccessfullySentTo'.tr()}$driverName',
              widget: Column(
                children: [
                  Text(
                    'amount'.tr(),
                    style: context.textStyle.labelSmallMedium,
                  ),
                  Text(
                    amount.toString(),
                    style: context.textStyle.titleXlargeRegular,
                  ),
                ],
              ),
            ),
          ).then((value) {
            NavigationManager.instance.navigationToPage(
              NavigationConstant.homePage,
            );
          });
        } else {
          // TODO: error page
        }
      }
    } catch (e) {
      // TODO:
    }
  }

  Future<void> addCard(PaymentModel model) async {
    var response = await PaymentService.instance.addCard(model);
    print(response);
    if (response == '') {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.paymentMethod);
    } else {
      // TODO: hata pop up
    }
  }

  void goToAddCardPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.addCard);
  }
}
