import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/theme/styles.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/textfields/email_text_form_field.dart';
import '../../widgets/textfields/name_text_from_field.dart';
import '../../widgets/textfields/tc_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).scaffoldBackgroundColor; // Body rengini al
    Brightness currentBrightness = Theme.of(context).brightness; // Tema parlaklığını al
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: currentBrightness == Brightness.light ? SvgPicture.asset('assets/svg/angle-left.svg') : SvgPicture.asset('assets/svg/angle-left_white.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Back',
              style: AppTextStyles.subheadLargeRegular.copyWith(
                color: currentBrightness == Brightness.light ? AppThemes.contentSecondary : Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 30),
                child: Text(
                  'Sign Up',
                  style: AppTextStyles.titleMedMedium,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, top: 24, right: 16),
            height: context.responsiveHeight(60),
            width: context.responsiveWidth(362),
            child: NameTextFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, top: 20, right: 16),
            height: context.responsiveHeight(60),
            width: context.responsiveWidth(362),
            child: EmailTextFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, top: 20, right: 16),
            height: context.responsiveHeight(60),
            width: context.responsiveWidth(362),
            child: TcTextFormField(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20, right: 16),
            child: IntlPhoneField(
              
              decoration: InputDecoration(
                hintText: 'Your mobile number',
                hintStyle: AppTextStyles.subheadLargeMedium.copyWith(
                  color: AppThemes.hintTextNeutral,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppThemes.borderSideColor,
                  ),
                ),
              ),
              initialCountryCode: AppLocalizations.of(context).localeName.toString().toUpperCase(),

              onChanged: (phone) {
                print(phone.completeNumber);
              },
            ),
          )
        ],
      ),
    );
  }
}
