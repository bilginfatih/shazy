import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/theme/themes.dart';
import '../../widgets/padding/base_padding.dart';
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
    Color appBarColor =
        Theme.of(context).scaffoldBackgroundColor; // Body rengini al
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: context.isLight
                  ? SvgPicture.asset('assets/svg/angle-left.svg')
                  : SvgPicture.asset('assets/svg/angle-left_white.svg'),
              onPressed: () {
                NavigationManager.instance.navigationToPop();
              },
            ),
            Text(
              'Back',
              style: context.textStyle.subheadLargeRegular.copyWith(
                color:
                    context.isLight ? AppThemes.contentSecondary : Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sign Up',
                  style: context.textStyle.titleMedMedium,
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveHeight(24),
            ),
            SizedBox(
              height: context.responsiveHeight(60),
              width: context.responsiveWidth(362),
              child: NameTextFormField(
                context: context,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            SizedBox(
              height: context.responsiveHeight(60),
              width: context.responsiveWidth(362),
              child: EmailTextFormField(
                context: context,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            SizedBox(
              height: context.responsiveHeight(60),
              width: context.responsiveWidth(362),
              child: TcTextFormField(
                context: context,
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(20),
            ),
            IntlPhoneField(
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
              initialCountryCode: AppLocalizations.of(context)
                  .localeName
                  .toString()
                  .toUpperCase(),
              onChanged: (phone) {
                print(phone.completeNumber);
              },
            )
          ],
        ),
      ),
    );
  }
}
