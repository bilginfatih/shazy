import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/models/payment/payment_model.dart';
import 'package:shazy/pages/payment/controller/payment_controller.dart';
import '../../utils/extensions/context_extension.dart';
import '../../widgets/app_bars/back_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/padding/base_padding.dart';
import '../../widgets/textfields/name_text_from_field.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/textfields/credit_card_text_form_field.dart';

class AddCard extends StatelessWidget {
  AddCard({super.key});

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();

  final PaymentController _controller = PaymentController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  /*
 // 3 payment text
  Container _buildContainer(BuildContext context) => Container(
        height: context.responsiveHeight(36),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppThemes.primary100,
          ),
          borderRadius: BorderRadius.circular(8),
          color: AppThemes.lightPrimary50,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SvgPicture.asset('assets/svg/check-circle.svg'),
              SizedBox(
                width: context.responsiveWidth(10),
              ),
              Text(
                'threeDSecure'.tr(),
                style: context.textStyle.subheadSmallRegular,
              )
            ],
          ),
        ),
      ); */

  Row _buildRow(BuildContext context) {
    return Row(
      children: [
        _buildLimitDigitTextFormField(
            context, _monthController, 'month'.tr(), 2),
        SizedBox(
          width: context.responsiveWidth(6),
        ),
        _buildLimitDigitTextFormField(context, _yearController, 'year'.tr(), 2),
        SizedBox(
          width: context.responsiveWidth(6),
        ),
        _buildCvvTextFormField(context),
      ],
    );
  }

  SizedBox _buildCvvTextFormField(BuildContext context) => SizedBox(
        width: context.responsiveWidth(116),
        child: TextFormField(
          controller: _cvvController,
          obscureText: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: _buildInputDecoration(
            context,
            'CVV',
            suffixIcon: _buildHelpSupportIcon(context),
          ),
        ),
      );

  Padding _buildHelpSupportIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(10.0),
        bottom: context.responsiveHeight(10.0),
      ),
      child: SvgPicture.asset(
        'assets/svg/help-support.svg',
      ),
    );
  }

  SizedBox _buildLimitDigitTextFormField(BuildContext context,
          TextEditingController controller, String text, int limit) =>
      SizedBox(
        width: context.responsiveWidth(116),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(limit),
          ],
          decoration: _buildInputDecoration(context, text),
        ),
      );

  InputDecoration _buildInputDecoration(BuildContext context, String text,
          {Widget? suffixIcon}) =>
      InputDecoration(
        hintText: text,
        hintStyle: context.textStyle.subheadLargeMedium.copyWith(
          color: AppThemes.hintTextNeutral,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppThemes.borderSideColor,
          ),
        ),
      );

  PrimaryButton _buildButton(BuildContext context) {
    return PrimaryButton(
        text: 'addCard'.tr(),
        context: context,
        onPressed: () {
          PaymentModel model = PaymentModel(
            cardHolderName: _cardholderNameController.text,
            cardNumber: _cardNumberController.text,
            cvv: _cvvController.text,
            month: _monthController.text,
            year: _yearController.text,
          );
          _controller.addCard(context, model);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'addCard'.tr(),
      ),
      body: BasePadding(
          context: context,
          child: Column(
            children: [
              NameTextFormField(
                context: context,
                hintText: 'cardholderName'.tr(),
                controller: _cardholderNameController,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              CreditCardTextFormField(
                context: context,
                controller: _cardNumberController,
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              _buildRow(context),
              const Spacer(),
              _buildButton(context),
              SizedBox(
                height: context.responsiveHeight(16),
              )
            ],
          )),
    );
  }
}
