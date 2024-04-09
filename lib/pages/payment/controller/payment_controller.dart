import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/payment/payment_model.dart';
import 'package:shazy/services/payment/payment_service.dart';
import 'package:shazy/utils/extensions/context_extension.dart';

import '../../../core/init/cache/cache_manager.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../models/comment/comment_model.dart';
import '../../../services/comment/comment_service.dart';
import '../../../utils/constants/navigation_constant.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../../widgets/dialogs/congratulation_dialog.dart';
import '../../../widgets/dialogs/error_dialog.dart';
import '../../../widgets/modal_bottom_sheet/comment_bottom_sheet.dart';
import '../../history/controller/history_upcoming_controller.dart';
import '../../home/home_screen_transport.dart';
part 'payment_controller.g.dart';

class PaymentController = _PaymentControllerBase with _$PaymentController;

abstract class _PaymentControllerBase with Store {
  final TextEditingController _commentTextController = TextEditingController();
  final _controllerComment = HistoryUpcomingController();
  @observable
  PaymentModel card = PaymentModel();

  @action
  Future<void> init() async {
    card = await PaymentService.instance.getCard();
  }

  Future<void> pay(String amount, BuildContext context, {String driverName = ''}) async {
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
                    '${amount.toString()}₺',
                    style: context.textStyle.titleXlargeRegular,
                  ),
                ],
              ),
            ),
          ).then((value) {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              context: context,
              builder: (_) => Observer(builder: (context) {
                return CommentBottomSheet(
                  selectedIndex: _controllerComment.starSelectedIndex,
                  context: context,
                  textController: _commentTextController,
                  onPressed: () async {
                    await sendComment(_commentTextController.text, _controllerComment.starSelectedIndex);
                    CacheManager.instance.clearAll('directions');
                    CacheManager.instance.clearAll('caller_directions');
                    NavigationManager.instance.navigationToPageClear(NavigationConstant.homePage);
                  },
                  onPressedRatingBar: _controllerComment.changeStarSelectedIndex,
                  text: '${'youRated'.tr()} ${' ${_controllerComment.starSelectedIndex}'} ${'star'.tr()}',
                );
              }),
            );

            /*NavigationManager.instance.navigationToPage(
              NavigationConstant.homePage,
            );*/
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
        HelperFunctions.instance.showErrorDialog(context, 'payError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  Future<void> sendComment(String comment, int index) async {
    var model = CommentModel(comment: comment, point: index.toDouble());
    model.commentorUserId = await SessionManager().get('id');
    var response = await CommentService.instance.comment(model, 'caller');
    // NavigationManager.instance.navigationToPop();
    if (response != null) {}
  }

  Future<void> addCard(BuildContext context, PaymentModel model) async {
    var response = await PaymentService.instance.addCard(model);
    if (response == '') {
      if (HomeScreenTransport.flagWaitPayment == 0) {
        NavigationManager.instance.navigationToPageClear(NavigationConstant.paymentMethod);
      } else {
        NavigationManager.instance.navigationToPageClear(NavigationConstant.paymentTip);
      }
    } else {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(context, response, 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  void goToAddCardPage() {
    NavigationManager.instance.navigationToPage(NavigationConstant.addCard);
  }
}
