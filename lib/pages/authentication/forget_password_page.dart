import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shazy/core/init/navigation/navigation_manager.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/utils/theme/themes.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/containers/option_container.dart';
import 'package:shazy/widgets/icons/circular_svg_icon.dart';
import 'package:shazy/widgets/padding/base_padding.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool _selectSms = true;

  OptionContainer _buildOptionContainer(BuildContext context, bool select,
          String assetName, String text1, String text2) =>
      OptionContainer(
        context: context,
        onTap: () {
          setState(() {
            _selectSms = select;
          });
        },
        select: _selectSms == select,
        border: _selectSms == select
            ? Border.all(
                width: 1,
                color: AppThemes.lightTheme.colorScheme.primary,
              )
            : Border.all(
                width: 1,
                color: AppThemes.hintTextNeutral,
              ),
        child: Row(
          children: [
            CircularSvgIcon(
              context: context,
              assetName: assetName,
            ),
            SizedBox(width: context.responsiveWidth(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text1, style: context.textStyle.subheadSmallMedium),
                SizedBox(
                  width: context.responsiveWidth(250),
                  child: Text(
                    text2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: context.textStyle.subheadLargeMedium.copyWith(
                      color: HexColor('#5A5A5A'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context),
      body: BasePadding(
        context: context,
        child: Column(
          children: [
            Text(
              'Forgot Password',
              style: context.textStyle.titleMedMedium,
            ),
            SizedBox(
              height: context.responsiveHeight(12),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveWidth(25),
              ),
              child: Text(
                'Select which contact details should we use to reset your password',
                textAlign: TextAlign.center,
                style: context.textStyle.bodyLargeRegular.copyWith(
                  color: HexColor('#D0D0D0'),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveHeight(36),
            ),
            _buildOptionContainer(
                context, true, 'assets/svg/sms.svg', 'Via SMS', '***** ***70'),
            SizedBox(
              height: context.responsiveHeight(16),
            ),
            _buildOptionContainer(context, false, 'assets/svg/email.svg',
                'Via Email', '**** **** **** xyz@xyz.com'),
            const Spacer(),
            PrimaryButton(
              text: 'Continue',
              context: context,
              onPressed: () {
                NavigationManager.instance
                    .navigationToPage(NavigationConstant.phoneVerifiyOtpPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
