import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:shazy/pages/payment/controller/payment_controller.dart';

import '../../core/base/app_info.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/navigation_constant.dart';
import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/containers/payment_method_container.dart';
import '../../widgets/dialogs/congratulation_dialog.dart';
import '../../widgets/padding/base_padding.dart';

class PaymentTipPage extends StatefulWidget {
  const PaymentTipPage({super.key});



class _PaymentTipPageState extends State<PaymentTipPage> {
  final PaymentController _controller = PaymentController();

  @override
  void initState() {
    _controller.init();
    super.initState();
  }

  /*Container _buildTipContainer(BuildContext context, String text,
      {bool isSelected = false}) {

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppThemes.lightPrimary500 : HexColor('#DDDDDD'),
          ),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: context.textStyle.bodyLargeMedium.copyWith(
          color: isSelected ? AppThemes.lightPrimary500 : HexColor('#5A5A5A'),
        ),
      ),
    );
  }*/
  Row _buildRowText(String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          text2,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /*Row _buildTipRow(BuildContext context) {
    return Row(
      children: [
        _buildTipContainer(context, '10₺'),
        SizedBox(width: context.responsiveWidth(6)),
        _buildTipContainer(context, '15₺', isSelected: true),
        SizedBox(width: context.responsiveWidth(6)),
        _buildTipContainer(context, '20₺'),
        SizedBox(width: context.responsiveWidth(6)),
        _buildTipContainer(context, '25₺'),
        SizedBox(width: context.responsiveWidth(6)),
        _buildTipContainer(context, '30₺'),
      ],
    );

  }*/

  void _onPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SuccessDialog(
        context: context,
        title: 'Payment Success',
        text1: 'Your money has been successfully sent to mha',
        widget: Column(
          children: [
            Text(
              'Amount',
              style: context.textStyle.labelSmallMedium,
            ),
            Text(
              Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null
                  ? "${Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.totalPayment.toString()}₺"
                  : 'null',
              style: context.textStyle.titleXlargeRegular,
            ),
          ],
        ),
      ),
    );
  }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'payment'.tr(),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'orderSummary'.tr(),
              style: context.textStyle.subheadLargeMedium.copyWith(
                color: HexColor('#5A5A5A'),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),

            _buildRowText(
              'Charge',
              Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null
                  ? "${Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.totalPayment.toString()}₺"
                  : 'null',
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'selectPaymentMethod'.tr(),
                  style: context.textStyle.headlineSmallMedium,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationManager.instance.navigationToPage(NavigationConstant.addCard);
                  },
                  child: Text(

                    'addCard'.tr(),
                    style: context.textStyle.subheadLargeSemibold
                        .copyWith(color: AppThemes.secondary700),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(26),
            ),
            _buildPaymentMethod(context),
            const Spacer(),
            PrimaryButton(
                text: 'submit'.tr(),
                context: context,
                onPressed: () async {
                  await _controller.pay(200, context);
                }),
            SizedBox(
              height: context.responsiveHeight(16),
            )
          ],
        ),
      ),
    );
  }

  SingleChildRenderObjectWidget _buildPaymentMethod(BuildContext context) {
    return _controller.card.cardNumber != null &&
            _controller.card.month != null &&
            _controller.card.year != null
        ? PaymetMethodContainer(
            context: context,
            //assetName: 'visa',
            text1:
                '**** **** **** ${_controller.card.cardNumber?.substring(_controller.card.cardNumber!.length - 5)}',
            text2:
                'Expires: ${_controller.card.month}/${_controller.card.year}',
            opacitiy: 1,
          )
        : Center(
            child: Text(
              'noPaymentMethod'.tr(),
              style: context.textStyle.titleSmallMedium
                  .copyWith(color: HexColor('#898989')),
            ),
          );
  }
}
