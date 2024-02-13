import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/payment/payment_model.dart';
import 'package:shazy/services/payment/payment_service.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../widgets/dialogs/congratulation_dialog.dart';
import '../../../widgets/dialogs/error_dialog.dart';
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
      card.amount = amount;
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
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(
              context: context,
              title: response,
              buttonText: 'cancel'.tr(),
              onPressed: () {
                NavigationManager.instance.navigationToPop();
              },
            ),
          );
        }
      }
    } catch (e) {
 if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'payError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }   }
  }

  Future<void> addCard(BuildContext context, PaymentModel model) async {
    var response = await PaymentService.instance.addCard(model);
    if (response == '') {
      NavigationManager.instance
          .navigationToPageClear(NavigationConstant.paymentMethod);
    } else {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, response, 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  void goToAddCardPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.addCard);
  }
}
