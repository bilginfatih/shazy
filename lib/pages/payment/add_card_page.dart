import 'package:flutter/material.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/padding/base_padding.dart';
import 'package:shazy/widgets/textfields/name_text_from_field.dart';

import '../../utils/theme/themes.dart';

class AddCard extends StatelessWidget {
  AddCard({super.key});
  final TextEditingController _cardholderNameController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

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
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  hintText: 'Card Number',
                  hintStyle: context.textStyle.subheadLargeMedium.copyWith(
                    color: AppThemes.hintTextNeutral,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppThemes.borderSideColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: context.responsiveHeight(20),
              ),
              Row(
                children: [
                  SizedBox(
                    width: context.responsiveWidth(116),
                    child: TextFormField(
                      controller: _monthController,
                      decoration: InputDecoration(
                        hintText: 'Month',
                        hintStyle:
                            context.textStyle.subheadLargeMedium.copyWith(
                          color: AppThemes.hintTextNeutral,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemes.borderSideColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(6),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(116),
                    child: TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        hintText: 'Year',
                        hintStyle:
                            context.textStyle.subheadLargeMedium.copyWith(
                          color: AppThemes.hintTextNeutral,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemes.borderSideColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(6),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(116),
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        hintStyle:
                            context.textStyle.subheadLargeMedium.copyWith(
                          color: AppThemes.hintTextNeutral,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemes.borderSideColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: context.responsiveHeight(28),
              ),
              Spacer(),
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
