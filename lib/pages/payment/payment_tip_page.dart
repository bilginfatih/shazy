import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../widgets/containers/payment_method_container.dart';
import '../../widgets/dialogs/congratulation_dialog.dart';

class PaymentTipPage extends StatelessWidget {
  const PaymentTipPage({super.key});

  Container _buildTipContainer(BuildContext context, String text,
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
  }

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

  Row _buildTipRow(BuildContext context) {
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
  }

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
              '\$220',
              style: context.textStyle.titleXlargeRegular,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Payment',
      ),
      body: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: context.textStyle.subheadLargeMedium.copyWith(
                color: HexColor('#5A5A5A'),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(10),
            ),
            _buildRowText('Charge', '200₺'),
            SizedBox(
              height: context.responsiveHeight(9),
            ),
            _buildRowText('Commission', '20₺'),
            SizedBox(
              height: context.responsiveHeight(9),
            ),
            _buildRowText('Total Amount', '220₺'),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select payment method',
                  style: context.textStyle.headlineSmallMedium,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationManager.instance
                        .navigationToPage(NavigationConstant.addCard);
                  },
                  child: Text(
                    'Add Card',
                    style: context.textStyle.subheadLargeSemibold
                        .copyWith(color: AppThemes.secondary700),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(26),
            ),
            PaymetMethodContainer(
              context: context,
              assetName: 'visa',
              text1: '**** **** **** 8970',
              text2: 'Expires: 12/26',
              opacitiy: 1,
            ),
            SizedBox(
              height: context.responsiveHeight(8),
            ),
            PaymetMethodContainer(
              context: context,
              assetName: 'mastercard',
              text1: '**** **** **** 8970',
              text2: 'Expires: 12/26',
            ),
            SizedBox(
              height: context.responsiveHeight(31),
            ),
            Center(
              child: Text(
                'Give some tips to Zübeyir X',
                style: context.textStyle.subheadLargeMedium,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(24),
            ),
            _buildTipRow(context),
            SizedBox(
              height: context.responsiveHeight(12),
            ),
            Center(
              child: Text(
                'Enter other amount',
                style: context.textStyle.bodySmallMedium
                    .copyWith(color: AppThemes.secondary700),
              ),
            ),
            const Spacer(),
            PrimaryButton(
                text: 'Submit',
                context: context,
                onPressed: () {
                  _onPressed(context);
                }),
            SizedBox(
              height: context.responsiveHeight(16),
            )
          ],
        ),
      ),
    );
  }
}
