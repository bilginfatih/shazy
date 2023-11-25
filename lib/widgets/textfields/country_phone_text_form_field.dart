import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../utils/extensions/context_extension.dart';
import '../../utils/theme/themes.dart';

class CountryPhoneTextFormField extends IntlPhoneField {
  CountryPhoneTextFormField({
    Key? key,
    TextEditingController? controller,
    required BuildContext context,
  }) : super(
          key: key,
          controller: controller,
          // Ülkelere göre telefon kodu getirme paketi
          // ignore: deprecated_member_use
          searchText: "Search Country",
          dropdownIcon: const Icon(Icons.keyboard_arrow_down),
          dropdownIconPosition: IconPosition.trailing,
          dropdownDecoration: BoxDecoration(
            border: Border(right: BorderSide(color: context.isLight ? HexColor("#DDDDDD") : HexColor("#D0D0D0"))),
          ),
          //languageCode: AppLocalizations.of(context).localeName.toString(),
          //initialCountryCode: AppLocalizations.of(context).localeName.toString().toUpperCase(),
          flagsButtonMargin: EdgeInsets.symmetric(horizontal: context.responsiveWidth(7)),
          decoration: InputDecoration(
            hintText: 'Your mobile number',
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
          onChanged: (phone) {},
        );
}
