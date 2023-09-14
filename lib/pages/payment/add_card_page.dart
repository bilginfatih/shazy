import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/padding/base_padding.dart';
import 'package:shazy/widgets/textfields/name_text_from_field.dart';

import '../../utils/theme/themes.dart';
import '../../widgets/textfields/credit_card_text_form_field.dart';

class AddCard extends StatelessWidget {
  AddCard({super.key});

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();

  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

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
                '3D Secure',
                style: context.textStyle.subheadSmallRegular,
              )
            ],
          ),
        ),
      );

  Row _buildRow(BuildContext context) {
    return Row(
      children: [
        _buildTwoDigitTextFormField(context, _monthController, 'Month'),
        SizedBox(
          width: context.responsiveWidth(6),
        ),
        _buildTwoDigitTextFormField(context, _yearController, 'Month'),
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

  SizedBox _buildTwoDigitTextFormField(BuildContext context,
          TextEditingController controller, String text) =>
      SizedBox(
        width: context.responsiveWidth(116),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'Add Card',
      ),
      body: BasePadding(
          context: context,
          child: Column(
            children: [
              NameTextFormField(
                context: context,
                hintText: 'Cardholder name',
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
              Padding(
                padding: EdgeInsets.only(top: context.responsiveHeight(20)),
                child: _buildContainer(context),
              ),
              const Spacer(),
              PrimaryButton(
                  text: 'Add Card', context: context, onPressed: () {}),
              SizedBox(
                height: context.responsiveHeight(16),
              )
            ],
          )),
    );
  }
}
